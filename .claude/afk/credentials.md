# Credentials

The kit standard for credentials: passwords, tokens, API keys, private keys,
recovery codes, account numbers, and anything else that unlocks something.
It applies wherever the Credentials setting in `CLAUDE.md` reads
`kit standard`. A repository that keeps no credentials leaves the setting at
`none`. One that keeps them its own way, or whose build neither decrypter
below can serve, names its own place or rule in that setting, with the
reason the kit standard does not serve, and then nothing here applies to
it. Finding another way to decrypt is that repository's work, not the
kit's.

The standard commits credentials only in a repository confirmed private.
`HOUSE.md` says what happens to a value anywhere else: it is committed
nowhere and goes in the reply for the owner to place.

## The files

A credential lives in a `<slug>.secrets.md` file. When it belongs to a file
in the repository that has a slug, such as an entry, a page or a service's
configuration, it sits beside that file under the same slug. When it belongs
to nothing in the repository, it goes in `secrets/` at the root, under a slug
naming the service it unlocks.

````markdown
---
slug: <slug>
updated: <YYYY-MM-DD>
---

**<Label naming what this value unlocks>**

```age
-----BEGIN AGE ENCRYPTED FILE-----
<the value, encrypted>
-----END AGE ENCRYPTED FILE-----
```

<Optional note: where the value is used, why it is recorded, what rotating
it breaks.>
````

- Two frontmatter fields, `slug` and `updated`, and nothing else. `slug`
  matches the filename.
- One bold label per value, and one value per label. The label and the note
  are never encrypted and never hold a value, so anyone can tell what each
  value unlocks without a key.
- Each value is recorded in full before it is encrypted: never masked,
  truncated or replaced by a reference.
- Each value is encrypted on its own, with age, to every public key in
  `secrets-recipients.txt`, and written as an ASCII armored block fenced and
  tagged `age`. A value of more than one line, such as a private key or a list
  of recovery codes, is one value in one block.
- A value in plaintext is a backticked line, or a fenced block not tagged
  `age`. Every one is a failure that `secrets.py check` reports, and
  `secrets.py lock` encrypts it. A value in a table cannot be encrypted, and
  the table is rewritten as one labelled value per block first.

A session reference's companion,
`.claude/references/<yymmddhhmmss>-<task-slug>.secrets.md`, is a secrets file
in the same form, holding a dated copy of every value the session handled,
by `.claude/afk/references.md`. A value whose `<slug>.secrets.md` does not
exist yet lives there alone until a task places it. An older `HANDOFF.md`
may still hold values under Credentials In Transit, in the same form, and
the tool still reads, checks and re-encrypts them there. Move each into a
companion when the repository updates to a kit with companions.

`todo_sweep.py` never reads a `<slug>.secrets.md` file.

## The keys

`secrets-recipients.txt` at the repository root holds one age public key per
line, each under a comment naming who holds the private half. A public key
can only encrypt, so the file is committed. Any one matching private key
decrypts every value.

Three keys is the default set: the owner's own, one held by the build or
deploy host as the encrypted variable `SECRETS_AGE_KEY`, and a recovery key
kept apart from the owner's for whoever continues without the owner. A
repository that names another set, in its authority file or `CLAUDE.md`,
overrules the default. One key works. A key lost with no other left loses
every value in the repository.

A private key is a line beginning `AGE-SECRET-KEY-1`. It is never committed,
never written into a state file, never pasted into a conversation, and never
held by a session. The owner makes each key on their own computer and gives
the session only its public line, with who holds it. `secrets.py keys`
prints the steps, for the default set or for the holders named after it,
such as `secrets.py keys owner build`, and the session gives the owner its
output whole. The session then writes `secrets-recipients.txt` from the
lines returned, each under a comment naming its holder.

## The tool

`.claude/afk/secrets.py` does every operation. It needs `python3` and the
`age` command line tool, except `check`, which needs `python3` alone. Run
`python3 .claude/afk/secrets.py --help` for its commands.

| To | Run |
|---|---|
| Store a value | `secrets.py set <file> "<label>"`, the value on standard input. A label already there has its value replaced |
| Store a value the owner encrypted | `secrets.py place <file> "<label>" < <armored file>` |
| Hold a value whose home is not settled | `set` or `place` with the session's companion as the file |
| Encrypt plaintext already in a file | `secrets.py lock <file>` |
| Print one encrypted block | `secrets.py encrypt`, the value on standard input |
| Check every value is encrypted | `secrets.py check` |
| Give the owner the steps to encrypt on their own computer | `secrets.py steps` |
| Give the owner the steps to make the keys | `secrets.py keys`, or `secrets.py keys <holder>...` |
| Decrypt for a build | `secrets.py decrypt --out <dir>`, as Decrypting for a build says |
| Read the values | `secrets.py show <file> --identity <key file>`, on the owner's computer |
| Change who can read | Edit `secrets-recipients.txt`, then `secrets.py rekey --identity <key file>`, on the owner's computer |

A value is never put on a command line, where it lands in shell history.
`set` and `encrypt` read it from standard input, and a session pipes it in
from a file outside the repository or from a heredoc in the command it
runs, never as an argument. After storing a value, search the working tree for it, printing a count
and never the value, and commit only when the count is zero.

`place` refuses a block that is not armored age, is encrypted to a passphrase
rather than to keys, or is encrypted to a different number of keys than
`secrets-recipients.txt` lists. A block encrypted to the right number of the
wrong keys passes `place` and fails the first time a key tries to read it.

## Keeping the plaintext out of the session

A value a session produced or was given is in the conversation already, and
the session stores it with `set`. A value the owner has not yet given is
better never given in plaintext: the session runs `secrets.py steps` and
gives the owner its output whole. The owner encrypts the value on their own
computer, attaches the armored file it writes, and says what it unlocks, and
the session stores it with `place`.

Whenever anyone asks how to encrypt a value to hand to a session, the
answer is `secrets.py steps`, run in that repository, so the steps carry
its own keys. Never give steps written from memory or copied from another
repository: a value encrypted to the wrong keys reads nowhere.

## Decrypting for a build

A build that reads the values runs, as its first step:

```
python3 .claude/afk/secrets.py decrypt --out <dir>
```

It copies every `<slug>.secrets.md` to the same path under `<dir>` with each
value in plaintext, written as `show` writes it, and later steps read the
copy in place of the encrypted file. `HANDOFF.md` and the companions under
`.claude/references/` are never decrypted.

- The private key comes from `SECRETS_AGE_KEY`, set on the build host as
  an encrypted variable holding the build's key.
- `<dir>` must be outside the repository or ignored by git, and it refuses
  otherwise, so a decrypted copy is never committed.
- It fails, writing nothing, when the key is missing or a value will not
  decrypt, naming the file and label and never the value. A build without
  its credentials looks complete and is not.
- With `SECRETS_CHECK_BUILD=1` it needs no key and no `age` tool, and writes
  `secrets-check-build-placeholder` for every value, so continuous
  integration can build without a key.
- A value encrypted on Windows has its `\r\n` line endings and one trailing
  line break dropped, so it reads as typed.

It needs `python3`, and the `age` tool except in a check build. A build host
that lacks `age` installs it in the build's first step, from its package
manager.

**The Node decrypter.** Offer it only when `secrets.py decrypt` cannot run
on the build host, such as a host with Node and no `python3`, or one where
`age` cannot be installed. `node .claude/afk/secrets-decrypt.mjs --out <dir>`
does the same, with the same output, refusals and check build. It needs the
`age-encryption` package, which the repository adds to its own
`package.json`, pinned in its lockfile.

When neither can run on the build host, the kit standard does not serve that
repository. The owner decides whether it keeps its credentials its own way,
named in the Credentials setting with that reason.

## Reading a value without the kit

age is an open format with more than one implementation. Copy the lines from
`-----BEGIN AGE ENCRYPTED FILE-----` to `-----END AGE ENCRYPTED FILE-----`
into a file and run `age --decrypt --identity <key file> <that file>`.

## Changing a key

When a key is lost, exposed, or passes to someone else:

1. The owner makes a new key with `age-keygen -o <file>`.
2. Replace that key's line in `secrets-recipients.txt`.
3. On a computer holding any current private key, run
   `python3 .claude/afk/secrets.py rekey --identity <key file>`. It
   re-encrypts every value in every `<slug>.secrets.md` file and in
   `HANDOFF.md` to the keys now listed.
4. When a host holds a key as a variable, set the new one there before the
   push.
5. Commit and push.

A removed key still reads every copy made before the rekey, including every
one in the git history. A value that key may have exposed is changed at its
source, not only re-encrypted.

## Setting it up

Setup runs when the Credentials setting becomes `kit standard`: at the
first run, or later when the owner asks to keep credentials in the
repository. A session that meets a credential in a repository set to `none`
puts it in the reply, as `HOUSE.md` says, and asks the owner whether to
switch. Setup runs on a task branch, in this order, and each step that waits
on the owner is an `Action needed:` line at the top of part 1 of the reply
until it is done.

1. **Confirm the repository is private,** through the session's GitHub
   access. A public repository, or one whose visibility cannot be
   confirmed, stays at `none`, and setup stops there.
2. **The keys.** When there is no `secrets-recipients.txt`, run
   `secrets.py keys`, naming the holders when the repository names its own
   set, and give the owner its output whole. Write the file from the public
   lines returned. Until then, a credential goes in the reply rather than
   the repository.
3. **The repository's own checks.** Read the repository for what could
   expose a credential that `secrets.py check` cannot see: a build that
   publishes files, a search index, logs, an output directory, a
   configuration file that takes a value. For each, write a command that
   fails when a value or an encrypted block reaches it, as a script in the
   repository, and list each command under the Secrets checks setting. With
   nothing to check, the setting is `none`.
4. **Continuous integration.** When the repository has CI configuration, add
   a step running `python3 .claude/afk/secrets.py check` and each Secrets
   checks command, with no key, after a check build when a check reads the
   build's output. When it has none, the line is
   `Action needed:` run those commands on every pull request.
5. **The build,** when one reads the values. Make its first step
   `secrets.py decrypt`, as Decrypting for a build says, and point the
   steps after it at the decrypted copy. Add the output directory to
   `.gitignore`. Use `SECRETS_CHECK_BUILD=1` wherever the build runs without
   a key, such as in CI. Then `Action needed:` set the build's private key as
   the encrypted variable `SECRETS_AGE_KEY` on the build host.

When a container lacks the `age` tool, the session installs it with the
system's package manager if it can, and otherwise puts the value in the
reply and says why.
