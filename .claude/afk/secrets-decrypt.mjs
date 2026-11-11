#!/usr/bin/env node
// Decrypt a repository's *.secrets.md files for a build, in Node.
//
// The same command as `secrets.py decrypt`, for a build host that has Node
// and cannot run python3 or the age command line tool. Use secrets.py where
// it runs: .claude/afk/credentials.md says when this one is offered.
//
//   node .claude/afk/secrets-decrypt.mjs --out <dir>
//
// Copies every <slug>.secrets.md outside .claude/references/ and
// .claude/imported/ to the same path under <dir>, which git must ignore, with each value in plaintext.
// The private key comes from the SECRETS_AGE_KEY environment variable.
// Fails on a missing key or a value that will not decrypt, naming the file
// and label and never the value.
// With SECRETS_CHECK_BUILD=1 it needs no key and writes a placeholder for
// every value. A value encrypted on Windows has its \r\n line endings and
// one trailing line break dropped, so it reads as typed.
//
// Needs the age-encryption package, which the repository adds to its own
// package.json, pinned in its lockfile.

import { execFileSync, spawnSync } from "node:child_process";
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, relative, resolve, isAbsolute } from "node:path";

const SUFFIX = ".secrets.md";
// A session reference's companion is a dated copy, never read by a build.
const REFERENCES = ".claude/references/";
// A verbatim copy of what the repository was given, never read by a build.
const IMPORTED = ".claude/imported/";
const PLACEHOLDER = "secrets-check-build-placeholder";
const AGE_FENCE = /^```age\s*$/;
const ANY_FENCE = /^\s*(`{3,}|~{3,})\s*([^`]*?)\s*$/;
const VALUE_LINE = /^`([^`]+)`\s*$/;
const LABEL_LINE = /^\*\*.+\*\*\s*$/;

class Refusal extends Error {}

function units(lines) {
  // The same reading as units() in secrets.py: age blocks, and plaintext
  // values, which are backticked lines and fenced blocks not tagged age.
  const found = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (AGE_FENCE.test(line)) {
      let end = -1;
      for (let j = i + 1; j < lines.length; j++) if (/^```\s*$/.test(lines[j])) { end = j; break; }
      if (end < 0) throw new Refusal(`an age block opened on line ${i + 1} is never closed`);
      found.push({ kind: "block", start: i, end, armor: lines.slice(i + 1, end).join("\n") });
      i = end + 1;
      continue;
    }
    const fence = ANY_FENCE.exec(line);
    if (fence) {
      const [, run, info] = fence;
      if (info === "age") {
        throw new Refusal(`the age block on line ${i + 1} is not fenced with exactly three backticks at the start of the line`);
      }
      const close = new RegExp(`^\\s*\\${run[0]}{${run.length},}\\s*$`);
      let end = -1;
      for (let j = i + 1; j < lines.length; j++) if (close.test(lines[j])) { end = j; break; }
      if (end < 0) throw new Refusal(`a fenced block opened on line ${i + 1} is never closed`);
      if (lines.slice(i + 1, end).join("\n").trim()) found.push({ kind: "value", start: i, end });
      i = end + 1;
      continue;
    }
    if (VALUE_LINE.test(line)) found.push({ kind: "value", start: i, end: i });
    i += 1;
  }
  return found;
}

function labelOf(lines, unit) {
  for (let n = unit.start - 1; n >= 0; n--) {
    if (!lines[n].trim()) continue;
    if (LABEL_LINE.test(lines[n])) return lines[n].trim().slice(2, -2);
    break;
  }
  return `the value on line ${unit.start + 1}`;
}

function valueLines(value) {
  // How secrets.py show writes a value: a backticked line, or a fence.
  if (!value.includes("\n") && !value.includes("`")) return ["`" + value + "`"];
  const longest = Math.max(2, ...(value.match(/`+/g) || []).map((run) => run.length));
  const fence = "`".repeat(longest + 1);
  return [fence, ...value.split("\n"), fence];
}

function git(args, cwd) {
  return execFileSync("git", args, { cwd, encoding: "utf8" });
}

async function main(argv) {
  if (argv.length !== 2 || argv[0] !== "--out") throw new Refusal("needs an output directory: --out <dir>");
  let top;
  try {
    top = git(["rev-parse", "--show-toplevel"]).trim();
  } catch {
    throw new Refusal("not inside a git repository");
  }
  const out = resolve(argv[1]);
  const inside = relative(top, out);
  if (!inside.startsWith("..") && !isAbsolute(inside)) {
    if (inside === "") throw new Refusal("the output directory cannot be the repository itself");
    const ignored = spawnSync("git", ["check-ignore", "-q", "--no-index", inside + "/"], { cwd: top });
    if (ignored.status !== 0) {
      throw new Refusal(`${inside} is inside the repository and git does not ignore it. Add it to .gitignore`);
    }
  }

  const checkBuild = process.env.SECRETS_CHECK_BUILD === "1";
  const ids = (process.env.SECRETS_AGE_KEY || "").split(/\s+/).filter((w) => w.startsWith("AGE-SECRET-KEY-"));
  let decrypter;
  let armor;
  if (!checkBuild) {
    if (!ids.length) throw new Refusal("no private key. Set SECRETS_AGE_KEY, or SECRETS_CHECK_BUILD=1 for a check build");
    let age;
    try {
      age = await import("age-encryption");
    } catch {
      throw new Refusal("the age-encryption package is not installed. Add it to the repository's package.json");
    }
    decrypter = new age.Decrypter();
    for (const id of ids) decrypter.addIdentity(id);
    armor = age.armor;
  }

  const listed = git(["ls-files", "-z", "--cached", "--others", "--exclude-standard", "--", "*" + SUFFIX], top);
  const files = [...new Set(listed.split("\0").filter(Boolean))]
    .filter((rel) => !rel.startsWith(REFERENCES) && !rel.startsWith(IMPORTED))
    .sort();
  const written = [];
  let total = 0;
  for (const rel of files) {
    let lines;
    try {
      lines = readFileSync(join(top, rel), "utf8").split("\n");
    } catch {
      continue;
    }
    let found;
    try {
      found = units(lines);
    } catch (error) {
      throw new Refusal(`${rel}: ${error.message}`);
    }
    const reps = [];
    for (const u of found) {
      if (u.kind !== "block") throw new Refusal(`${rel}: ${labelOf(lines, u)} is not encrypted. Run lock on the file`);
      let value = PLACEHOLDER;
      if (!checkBuild) {
        try {
          value = await decrypter.decrypt(armor.decode(u.armor.trim() + "\n"), "text");
        } catch {
          throw new Refusal(`${rel}: ${labelOf(lines, u)} will not decrypt with the key given`);
        }
        value = value.replace(/\r\n/g, "\n");
        if (value.endsWith("\n")) value = value.slice(0, -1);
      }
      reps.push({ ...u, with: valueLines(value) });
    }
    const copy = [...lines];
    for (const rep of reps.sort((a, b) => b.start - a.start)) copy.splice(rep.start, rep.end - rep.start + 1, ...rep.with);
    written.push([rel, copy]);
    total += reps.length;
  }
  for (const [rel, lines] of written) {
    const target = join(out, rel);
    mkdirSync(dirname(target), { recursive: true });
    writeFileSync(target, lines.join("\n"), { encoding: "utf8", mode: 0o600 });
  }
  const verb = checkBuild ? "Wrote a placeholder for" : "Decrypted";
  console.log(`${verb} ${total} value(s) in ${written.length} file(s) to ${argv[1]}`);
}

main(process.argv.slice(2)).catch((error) => {
  if (!(error instanceof Refusal)) throw error;
  process.stderr.write(`secrets-decrypt.mjs: ${error.message}\n`);
  process.exit(1);
});
