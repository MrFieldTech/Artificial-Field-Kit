# Notice

The practices in `.claude/afk/practices/` and the pull request body in
`session-close` step 8 are adapted from skills in
https://github.com/mattpocock/skills, rewritten for the kit's session
protocol. Each practice names the skill it came from:

| Kit file | Source skill |
|---|---|
| `.claude/afk/practices/grilling.md` | `grilling`, through `grill-me` |
| `.claude/afk/practices/diagnosing.md` | `diagnosing-bugs` |
| `.claude/afk/practices/retro.md` | `retro` |
| `.claude/afk/practices/questionnaire.md` | `to-questionnaire` |
| `.claude/afk/practices/writing-for-agents.md` | `writing-for-agents` |
| `.claude/skills/session-close/SKILL.md`, step 8 | `pr` |

Those skills are distributed under this license:

```
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

By the `pr` skill's own credits, its menu of summary visuals comes from the
`show-me` skill by Dex Horthy of HumanLayer.

## Mirrored skills and agents

The kit mirrors these sources bit for bit under `vendor/`, each with its
own license file, and installs their skills and agents. Each source's
license is also at `.claude/afk/licenses/<name>.txt`, and
`vendor/<name>.upstream` records the commit mirrored.

| `vendor/` name | Source | License |
|---|---|---|
| `emilkowalski-skills` | emilkowalski/skills | MIT |
| `cloudflare-security-audit-skill` | cloudflare/security-audit-skill | MIT |
| `anthropics-code-simplifier` | anthropics/claude-plugins-official, `plugins/code-simplifier/` | Apache License 2.0 |
| `mukul975-cybersecurity-skills` | mukul975/Anthropic-Cybersecurity-Skills | Apache License 2.0 |
