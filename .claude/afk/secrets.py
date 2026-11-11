#!/usr/bin/env python3
"""Encrypt, check and read the credentials in a repository's *.secrets.md files.

The kit standard for credentials, described in .claude/afk/credentials.md:
every value in a <slug>.secrets.md file is encrypted on its own, with age, to
every public key in secrets-recipients.txt at the repository root, and written
as an ASCII armored block fenced and tagged `age` under a bold label.
Credentials In Transit in HANDOFF.md holds values the same way.

Commands, run from anywhere in the repository:

  secrets.py set <secrets file> "<label>"
      Encrypt the value on standard input and store it under <label>,
      replacing the value already there. Creates the file if needed.
  secrets.py place <secrets file|HANDOFF.md> "<label>" < <block file>
      Store a value that arrived already encrypted, as the armored file age
      writes, under <label>. The session placing it never sees the plaintext.
  secrets.py lock <file>...
      Encrypt every plaintext value in place: a backticked line, or a fenced
      block not tagged `age`, which is how a value of more than one line is
      written and how show prints one.
  secrets.py encrypt
      Encrypt standard input and print the fenced block.
  secrets.py show <file> [--identity <key file>]
      Print the file with its values decrypted.
  secrets.py decrypt --out <dir> [--identity <key file>]
      For a build: copy every <slug>.secrets.md outside .claude/references/
      and .claude/imported/ to the same path under <dir>, which git must ignore, with each value in
      plaintext. Fails on a missing key or a value that will not decrypt,
      naming the file and label and never the value. With
      SECRETS_CHECK_BUILD=1 it needs no key and no age tool, and writes a
      placeholder for every value.
  secrets.py rekey [--identity <key file>]
      Re-encrypt every value, HANDOFF.md included, to the keys now listed in
      secrets-recipients.txt, after one is added or removed. Files under
      .claude/imported/ are left as their source encrypted them.
  secrets.py check
      Fail on a value outside an encrypted block, a block that is not armored
      age, a value with no label, or a file whose frontmatter does not name
      it. A copy under .claude/imported/ keeps the name it was given, so its
      frontmatter is not checked. Needs no key and no age tool.
  secrets.py steps
      Print the steps the owner follows to encrypt a value on their own
      computer, with the keys from secrets-recipients.txt written in.
  secrets.py keys [<holder>...]
      Print the steps the owner follows to make the keys on their own
      computer, one per holder, owner, build and recovery unless named.

Encrypting needs only secrets-recipients.txt. Reading needs a private key,
from the SECRETS_AGE_KEY environment variable or from --identity <key file>.
A value is never passed on the command line, where it would land in shell
history: set and encrypt read it from standard input. Nothing here prints a
value except show, which exists to print one.

Needs python3 and the age command line tool. check, keys, and decrypt in a
check build need python3 alone.
"""

import base64
import datetime
import os
import re
import shutil
import subprocess
import sys
import tempfile

SUFFIX = ".secrets.md"
# Session references and their companions, .claude/afk/references.md. A
# companion is a dated copy of values whose home is elsewhere, so a build
# never decrypts it.
REFERENCES = ".claude/references/"
# Verbatim copies of what the repository was given, .claude/afk/references.md
# Copies. A copy may be encrypted to another repository's keys, so nothing
# here re-encrypts or decrypts it.
IMPORTED = ".claude/imported/"
RECIPIENTS = "secrets-recipients.txt"
HANDOFF = "HANDOFF.md"
TRANSIT = "## Credentials In Transit"
ARMOR_BEGIN = "-----BEGIN AGE ENCRYPTED FILE-----"
ARMOR_END = "-----END AGE ENCRYPTED FILE-----"
# The first line of every age file. Written in two parts so the kit's check
# for addresses does not read the format's name as one.
AGE_MAGIC = "age-encryption" + ".org/v1"
# What a check build writes in place of every value.
PLACEHOLDER = "secrets-check-build-placeholder"
DEFAULT_HOLDERS = ["owner", "build", "recovery"]

AGE_FENCE = re.compile(r"^```age\s*$")
ANY_FENCE = re.compile(r"^\s*(`{3,}|~{3,})\s*([^`]*?)\s*$")
VALUE_LINE = re.compile(r"^`([^`]+)`\s*$")
LABEL_LINE = re.compile(r"^\*\*.+\*\*\s*$")


class Refusal(Exception):
    pass


# ----------------------------------------------------------------- the format

def units(lines):
    """Find the values in lines: fenced age blocks, and plaintext values.

    A plaintext value is a backticked line, or any fenced block not tagged
    `age`. A label and a note never hold a value, so a fenced block in a
    secrets file is never formatting. Each unit carries its line range.
    """
    found = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if AGE_FENCE.match(line):
            end = next((j for j in range(i + 1, len(lines)) if re.match(r"^```\s*$", lines[j])), -1)
            if end < 0:
                raise Refusal("an age block opened on line %d is never closed" % (i + 1))
            found.append({"kind": "block", "start": i, "end": end, "armor": "\n".join(lines[i + 1:end])})
            i = end + 1
            continue
        fence = ANY_FENCE.match(line)
        if fence:
            run, info = fence.group(1), fence.group(2)
            if info == "age":
                raise Refusal(
                    "the age block on line %d is not fenced with exactly three backticks "
                    "at the start of the line" % (i + 1)
                )
            close = re.compile(r"^\s*%s{%d,}\s*$" % (re.escape(run[0]), len(run)))
            end = next((j for j in range(i + 1, len(lines)) if close.match(lines[j])), -1)
            if end < 0:
                raise Refusal("a fenced block opened on line %d is never closed" % (i + 1))
            value = "\n".join(lines[i + 1:end])
            if value.strip():
                found.append({"kind": "value", "start": i, "end": end, "value": value})
            i = end + 1
            continue
        value = VALUE_LINE.match(line)
        if value:
            found.append({"kind": "value", "start": i, "end": i, "value": value.group(1)})
        i += 1
    return found


def table_values(lines):
    """Table rows holding a backticked span: a value lock cannot place."""
    return [n for n, line in enumerate(lines) if line.startswith("|") and re.search(r"`[^`]+`", line)]


def splice(lines, replacements):
    """Replace line ranges, last first so earlier indexes stay valid."""
    out = list(lines)
    for rep in sorted(replacements, key=lambda r: r["start"], reverse=True):
        out[rep["start"]:rep["end"] + 1] = rep["with"]
    return out


def block_lines(armor):
    return ["```age"] + armor.rstrip().split("\n") + ["```"]


def value_lines(value):
    """How a decrypted value is written: a backticked line, or a fence."""
    if "\n" not in value and "`" not in value:
        return ["`%s`" % value]
    longest = max([2] + [len(run) for run in re.findall(r"`+", value)])
    fence = "`" * (longest + 1)
    return [fence] + value.split("\n") + [fence]


def transit_range(lines):
    """The lines under Credentials In Transit in HANDOFF.md, as (start, end)."""
    start = next((n for n, line in enumerate(lines) if line.strip() == TRANSIT), -1)
    if start < 0:
        return None
    end = next((n for n in range(start + 1, len(lines)) if lines[n].startswith("## ")), len(lines))
    return start + 1, end


def is_handoff(path):
    return os.path.basename(path) == HANDOFF


def read(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read().split("\n")


def write(path, lines):
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(lines))


def today():
    return datetime.date.today().isoformat()


# ---------------------------------------------------------------- repository

def root():
    try:
        out = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True
        )
    except (OSError, subprocess.CalledProcessError):
        raise Refusal("not inside a git repository")
    return out.stdout.strip()


def under(top, path, prefix):
    return os.path.relpath(path, top).replace(os.sep, "/").startswith(prefix)


def secrets_files(top):
    """Every *.secrets.md file git tracks or would track, sorted."""
    out = subprocess.run(
        ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard", "--", "*" + SUFFIX],
        cwd=top, capture_output=True, text=True, check=True,
    ).stdout
    return sorted({os.path.join(top, p) for p in out.split("\0") if p and os.path.isfile(os.path.join(top, p))})


# ----------------------------------------------------------------------- keys

def recipients(top):
    path = os.path.join(top, RECIPIENTS)
    if not os.path.exists(path):
        raise Refusal(
            "%s does not exist, so there is no key to encrypt to. "
            ".claude/afk/credentials.md says how the owner makes the keys." % RECIPIENTS
        )
    keys = [line.strip() for line in read(path) if line.strip() and not line.strip().startswith("#")]
    bad = [key for key in keys if not re.match(r"^age1[0-9a-z]+$", key)]
    if bad:
        raise Refusal("%s holds %d line(s) that are not age public keys" % (RECIPIENTS, len(bad)))
    if not keys:
        raise Refusal("%s holds no public key" % RECIPIENTS)
    return keys


def identities(args):
    """The private keys, from --identity <file> or SECRETS_AGE_KEY."""
    text = os.environ.get("SECRETS_AGE_KEY", "")
    if "--identity" in args:
        at = args.index("--identity")
        if at + 1 >= len(args):
            raise Refusal("--identity needs a key file")
        with open(args[at + 1], encoding="utf-8") as handle:
            text = handle.read()
        del args[at:at + 2]
    return [word for word in text.split() if word.startswith("AGE-SECRET-KEY-")]


def need_identities(ids):
    if not ids:
        raise Refusal("no private key. Set SECRETS_AGE_KEY, or pass --identity <key file>")
    return ids


def age_tool():
    tool = shutil.which("age")
    if not tool:
        raise Refusal("the age command line tool is not installed. Install the age package, then run this again")
    return tool


def encrypt_value(value, keys):
    cmd = [age_tool(), "--armor"]
    for key in keys:
        cmd += ["--recipient", key]
    out = subprocess.run(cmd, input=value.encode("utf-8"), capture_output=True)
    if out.returncode:
        raise Refusal("age could not encrypt: %s" % out.stderr.decode("utf-8", "replace").strip())
    return out.stdout.decode("ascii").rstrip()


def decrypt_armor(armor, ids):
    """Decrypt one block. A value encrypted on Windows can carry \\r\\n line
    endings and a trailing line break; both are dropped, so it reads as typed."""
    workdir = tempfile.mkdtemp()
    try:
        key_file = os.path.join(workdir, "key")
        fd = os.open(key_file, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(fd, "w") as handle:
            handle.write("\n".join(ids) + "\n")
        out = subprocess.run(
            [age_tool(), "--decrypt", "--identity", key_file],
            input=(armor.rstrip() + "\n").encode("ascii"), capture_output=True,
        )
    finally:
        shutil.rmtree(workdir, ignore_errors=True)
    if out.returncode:
        raise Refusal("a value will not decrypt with the key given")
    value = out.stdout.decode("utf-8").replace("\r\n", "\n")
    return value[:-1] if value.endswith("\n") else value


def armor_header(armor):
    """Decode an armored block and return its header lines, or raise."""
    text = armor.replace("\r\n", "\n").strip()
    lines = text.split("\n")
    if lines[0] != ARMOR_BEGIN:
        raise Refusal("it is not an armored age file")
    if lines[-1] != ARMOR_END:
        raise Refusal("the armored block has no end line")
    try:
        binary = base64.b64decode("".join(line.strip() for line in lines[1:-1]), validate=True)
    except ValueError as error:
        raise Refusal("the armored block will not decode: %s" % error)
    head = binary[:4096].decode("latin-1").split("\n")
    if head[0] != AGE_MAGIC:
        raise Refusal("the block is not an age v1 file")
    stop = next((n for n, line in enumerate(head) if line.startswith("---")), len(head))
    return text, [line for line in head[1:stop] if line.startswith("-> ")]


def check_armor(text, keys):
    """A block handed over already encrypted must decode, be encrypted to
    public keys rather than a passphrase, and carry one stanza per key in
    secrets-recipients.txt. A stanza does not name its key, so whether those
    are the right keys shows only when a key decrypts it."""
    armor, stanzas = armor_header(text)
    if any(not line.startswith("-> X25519 ") for line in stanzas):
        raise Refusal("the block is encrypted to something other than age public keys, such as a passphrase")
    if len(stanzas) != len(keys):
        raise Refusal(
            "the block is encrypted to %d key(s) and %s holds %d. Encrypt it again to every key in that file"
            % (len(stanzas), RECIPIENTS, len(keys))
        )
    return armor


def read_stdin():
    if sys.stdin.isatty():
        sys.stderr.write("Paste the value, then press Enter and Ctrl-D.\n")
    value = sys.stdin.buffer.read().decode("utf-8")
    value = re.sub(r"\r?\n$", "", value)
    if not value:
        raise Refusal("nothing was read from standard input")
    return value


# ------------------------------------------------------------------- commands

def need_target(path):
    if not (path.endswith(SUFFIX) or is_handoff(path)):
        raise Refusal("%s is not a %s file or %s" % (path, SUFFIX, HANDOFF))


def store(path, label, block):
    """Write a block under its label, replacing the value already there."""
    if os.path.exists(path):
        lines = read(path)
    elif is_handoff(path):
        raise Refusal("%s does not exist" % path)
    else:
        slug = os.path.basename(path)[:-len(SUFFIX)]
        parent = os.path.dirname(path)
        if parent:
            os.makedirs(parent, exist_ok=True)
        lines = ["---", "slug: %s" % slug, "updated: %s" % today(), "---", ""]

    heading = "**%s**" % label
    span = transit_range(lines) if is_handoff(path) else (0, len(lines))
    if not span:
        raise Refusal("%s has no %s heading" % (path, TRANSIT))
    at = next((n for n in range(span[0], span[1]) if lines[n].strip() == heading), -1)
    if at < 0 and is_handoff(path):
        start, end = span
        body = [line for line in lines[start:end] if line.strip()]
        # The template's placeholder paragraph goes once a value is held.
        if body and body[0].startswith("None."):
            lines[start:end] = ["", heading, ""] + block + [""]
        else:
            while end > start and not lines[end - 1].strip():
                end -= 1
            lines[end:end] = ["", heading, ""] + block
    elif at < 0:
        while lines and lines[-1] == "":
            lines.pop()
        lines += ["", heading, ""] + block + [""]
    else:
        following = [
            u for u in units(lines)
            if u["start"] > at and all(not line.strip() for line in lines[at + 1:u["start"]])
        ]
        if following:
            lines = splice(lines, [dict(following[0], **{"with": block})])
        else:
            lines = splice(lines, [{"start": at, "end": at, "with": [heading, ""] + block}])

    lines = [
        "updated: %s" % today() if n < 4 and line.startswith("updated:") else line
        for n, line in enumerate(lines)
    ]
    write(path, lines)
    print('%s "%s" in %s' % ("Added" if at < 0 else "Replaced", label, path))


def cmd_set(args, ids):
    if len(args) != 2:
        raise Refusal('set needs a secrets file and a label: set <file> "<label>"')
    path, label = args
    need_target(path)
    keys = recipients(root())
    store(path, label, block_lines(encrypt_value(read_stdin(), keys)))


def cmd_place(args, ids):
    if len(args) != 2:
        raise Refusal('place needs a file and a label: place <file> "<label>" < <block file>')
    path, label = args
    need_target(path)
    if sys.stdin.isatty():
        raise Refusal('place reads the armored block from standard input: place <file> "<label>" < <block file>')
    keys = recipients(root())
    text = sys.stdin.buffer.read().decode("utf-8", "replace")
    store(path, label, block_lines(check_armor(text, keys)))


def cmd_lock(args, ids):
    if not args:
        raise Refusal("lock needs at least one file")
    keys = recipients(root())
    refused = []
    for path in args:
        lines = read(path)
        if table_values(lines):
            refused.append(path)
            continue
        plain = [u for u in units(lines) if u["kind"] == "value"]
        if is_handoff(path):
            span = transit_range(lines) or (0, 0)
            plain = [u for u in plain if span[0] <= u["start"] < span[1]]
        reps = [dict(u, **{"with": block_lines(encrypt_value(u["value"], keys))}) for u in plain]
        if reps:
            write(path, splice(lines, reps))
        print("%s: %d value(s) encrypted" % (path, len(reps)))
    if refused:
        raise Refusal(
            "%d file(s) hold values in a table, which cannot hold an encrypted block. "
            "Rewrite each as one labelled value per block, then lock it:\n  %s"
            % (len(refused), "\n  ".join(refused))
        )


def cmd_encrypt(args, ids):
    armor = encrypt_value(read_stdin(), recipients(root()))
    print("\n".join(block_lines(armor)))


def cmd_show(args, ids):
    if len(args) != 1:
        raise Refusal("show needs one file")
    need_identities(ids)
    lines = read(args[0])
    reps = [
        dict(u, **{"with": value_lines(decrypt_armor(u["armor"], ids))})
        for u in units(lines) if u["kind"] == "block"
    ]
    sys.stdout.write("\n".join(splice(lines, reps)))


def cmd_rekey(args, ids):
    need_identities(ids)
    top = root()
    keys = recipients(top)
    files = [p for p in secrets_files(top) if not under(top, p, IMPORTED)]
    if os.path.exists(os.path.join(top, HANDOFF)):
        files.append(os.path.join(top, HANDOFF))
    total = 0
    for path in files:
        lines = read(path)
        reps = []
        for u in units(lines):
            if u["kind"] != "block":
                continue
            try:
                value = decrypt_armor(u["armor"], ids)
            except Refusal:
                raise Refusal("the block on line %d of %s will not decrypt with the key given" % (u["start"] + 1, path))
            reps.append(dict(u, **{"with": block_lines(encrypt_value(value, keys))}))
        if reps:
            write(path, splice(lines, reps))
        total += len(reps)
    print("Re-encrypted %d value(s) to %d recipient(s)" % (total, len(keys)))


def problems_in(path, lines, span, frontmatter):
    """What check reports for one file, as messages."""
    rel = os.path.relpath(path)
    found = []
    try:
        all_units = units(lines)
    except Refusal as error:
        return ["%s: %s" % (rel, error)]
    start, end = span
    for u in all_units:
        if not start <= u["start"] < end:
            continue
        line = u["start"] + 1
        if u["kind"] == "value":
            found.append("%s:%d: a value outside an encrypted block. Run lock on the file" % (rel, line))
            continue
        try:
            armor_header(u["armor"])
        except Refusal as error:
            found.append("%s:%d: the age block does not hold an armored age file: %s" % (rel, line, error))
        before = next((lines[n] for n in range(u["start"] - 1, -1, -1) if lines[n].strip()), "")
        if not LABEL_LINE.match(before):
            found.append("%s:%d: the value has no bold label naming what it unlocks" % (rel, line))
    for n in table_values(lines[start:end]):
        found.append("%s:%d: a value in a table, which cannot be encrypted" % (rel, start + n + 1))
    if frontmatter:
        slug = os.path.basename(path)[:-len(SUFFIX)]
        close = next((n for n in range(1, len(lines)) if lines[n] == "---"), -1)
        fields = lines[1:close] if lines and lines[0] == "---" and close > 0 else None
        if fields is None:
            found.append("%s: opens without frontmatter" % rel)
        else:
            names = sorted(field.split(":", 1)[0] for field in fields if field.strip())
            if names != ["slug", "updated"]:
                found.append("%s: its frontmatter holds %s, not slug and updated alone" % (rel, ", ".join(names) or "nothing"))
            if "slug: %s" % slug not in fields:
                found.append("%s: its frontmatter slug does not match the filename, %s" % (rel, slug))
    return found


def cmd_check(args, ids):
    top = root()
    problems = []
    files = secrets_files(top)
    for path in files:
        lines = read(path)
        problems += problems_in(path, lines, (0, len(lines)), not under(top, path, IMPORTED))
    handoff = os.path.join(top, HANDOFF)
    held = 0
    if os.path.exists(handoff):
        lines = read(handoff)
        span = transit_range(lines)
        if span:
            problems += problems_in(handoff, lines, span, False)
            try:
                held = sum(1 for u in units(lines[span[0]:span[1]]) if u["kind"] == "block")
            except Refusal:
                pass
    if files or held:
        try:
            recipients(top)
        except Refusal as error:
            problems.append(str(error))
    if problems:
        raise Refusal("%d problem(s):\n  %s" % (len(problems), "\n  ".join(problems)))
    print("secrets: %d secrets file(s) and %d value(s) in transit, every value encrypted" % (len(files), held))


def cmd_steps(args, ids):
    keys = recipients(root())
    windows = ["cd %userprofile%\\Downloads"]
    windows += ["echo %s%s recipients.txt" % (key, ">" if n == 0 else ">>") for n, key in enumerate(keys)]
    windows.append("age -a -R recipients.txt > new-secret.txt")
    unix = ["cd ~/Downloads", "printf '%%s\\n' %s > recipients.txt" % " ".join(keys),
            "age -a -R recipients.txt > new-secret.txt"]
    print("Encrypt a value on your own computer, so its plaintext never enters a session.\n"
          "The age tool must be installed there.\n\n"
          "On Windows, open Command Prompt and paste:\n\n```\n%s\n```\n\n"
          "Command Prompt waits on an empty line. Paste the value, press Ctrl+Z, then Enter.\n\n"
          "On macOS or Linux, open a terminal and paste:\n\n```\n%s\n```\n\n"
          "The terminal waits on an empty line. Paste the value, press Enter, then Ctrl-D.\n\n"
          "new-secret.txt in Downloads now holds the value encrypted. Each run overwrites it,\n"
          "so hand it over before encrypting the next. Attach it to the session and say\n"
          "what it unlocks and where it belongs." % ("\n".join(windows), "\n".join(unix)))


def label_of(lines, unit):
    """The bold label above a value, without its asterisks, or its line."""
    before = next((lines[n] for n in range(unit["start"] - 1, -1, -1) if lines[n].strip()), "")
    if LABEL_LINE.match(before):
        return before.strip()[2:-2]
    return "the value on line %d" % (unit["start"] + 1)


def cmd_decrypt(args, ids):
    if len(args) != 2 or args[0] != "--out":
        raise Refusal("decrypt needs an output directory: decrypt --out <dir>")
    top = root()
    out = os.path.abspath(args[1])
    inside = os.path.relpath(out, top)
    if not inside.startswith(".."):
        if inside == ".":
            raise Refusal("the output directory cannot be the repository itself")
        ignored = subprocess.run(["git", "check-ignore", "-q", "--no-index", inside + "/"], cwd=top)
        if ignored.returncode:
            raise Refusal("%s is inside the repository and git does not ignore it. Add it to .gitignore" % inside)
    check_build = os.environ.get("SECRETS_CHECK_BUILD") == "1"
    if not check_build:
        if not ids:
            raise Refusal("no private key. Set SECRETS_AGE_KEY, or SECRETS_CHECK_BUILD=1 for a check build")
        age_tool()
    written = []
    total = 0
    for path in secrets_files(top):
        rel = os.path.relpath(path, top)
        if under(top, path, REFERENCES) or under(top, path, IMPORTED):
            continue
        lines = read(path)
        reps = []
        for u in units(lines):
            if u["kind"] != "block":
                raise Refusal("%s: %s is not encrypted. Run lock on the file" % (rel, label_of(lines, u)))
            if check_build:
                value = PLACEHOLDER
            else:
                try:
                    value = decrypt_armor(u["armor"], ids)
                except Refusal:
                    raise Refusal("%s: %s will not decrypt with the key given" % (rel, label_of(lines, u)))
            reps.append(dict(u, **{"with": value_lines(value)}))
        written.append((rel, splice(lines, reps)))
        total += len(reps)
    for rel, lines in written:
        target = os.path.join(out, rel)
        os.makedirs(os.path.dirname(target), exist_ok=True)
        fd = os.open(target, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as handle:
            handle.write("\n".join(lines))
    print("%s %d value(s) in %d file(s) to %s" % (
        "Wrote a placeholder for" if check_build else "Decrypted", total, len(written), args[1]))


def cmd_keys(args, ids):
    holders = args or DEFAULT_HOLDERS
    bad = [h for h in holders if not re.match(r"^[A-Za-z0-9][A-Za-z0-9_-]*$", h)]
    if bad:
        raise Refusal("a holder is one word of letters, digits, hyphens and underscores: %s" % ", ".join(bad))
    names = ["age-key-%s.txt" % h for h in holders]
    windows = ["cd %userprofile%"] + ["age-keygen -o %s" % n for n in names]
    unix = ["cd ~"] + ["age-keygen -o %s" % n for n in names]
    listing = "\n".join("  %s, held by: %s" % (n, h) for n, h in zip(names, holders))
    print("Make the keys on your own computer, so no private key ever enters a session.\n"
          "The age tool must be installed there.\n\n"
          "On Windows, open Command Prompt and paste:\n\n```\n%s\n```\n\n"
          "On macOS or Linux, open a terminal and paste:\n\n```\n%s\n```\n\n"
          "Each command makes one key file in your home folder:\n\n%s\n\n"
          "Each prints a line beginning \"Public key: age1\". Send the session those\n"
          "lines and who holds each key. Nothing else from the files is ever sent: the\n"
          "line beginning AGE-SECRET-KEY-1 in each is its private half.\n\n"
          "Then move each private key to its holder. The build's goes into the build\n"
          "host as the encrypted variable SECRETS_AGE_KEY. The recovery key is kept\n"
          "apart from yours, for whoever continues without you. Keep your own where\n"
          "only you can read it, and delete the copies you moved."
          % ("\n".join(windows), "\n".join(unix), listing))


COMMANDS = {
    "set": cmd_set, "place": cmd_place, "lock": cmd_lock, "encrypt": cmd_encrypt,
    "show": cmd_show, "rekey": cmd_rekey, "check": cmd_check, "steps": cmd_steps,
    "decrypt": cmd_decrypt, "keys": cmd_keys,
}


def main(argv):
    if not argv or argv[0] in ("-h", "--help", "help"):
        print(__doc__.strip())
        return 0 if argv else 1
    name, args = argv[0], list(argv[1:])
    if name not in COMMANDS:
        raise Refusal("unknown command %s. Commands: %s" % (name, ", ".join(COMMANDS)))
    ids = identities(args)
    COMMANDS[name](args, ids)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv[1:]))
    except Refusal as error:
        sys.stderr.write("secrets.py: %s\n" % error)
        sys.exit(1)
