---
name: harness2
description: Recursive harness refinement after a task, adapted from Google Research's Harness² (Propose–Probe–Compose + experience library). Use when the user runs /harness2, or asks to improve AGENTS.md, skills, subagent prompts, commands or plugins based on how a session actually went.
license: Apache-2.0
compatibility: opencode
metadata:
  origin: https://github.com/google-research/harness2 (method only, no code)
  audience: developers
---

# Harness² for OpenCode

The **harness** is everything around the model: instructions, guardrails, memory,
tool guidance, subagents, skills, scripts, plugins. This skill improves the harness
from **observed behaviour**, never by changing the model, and never from what merely
sounds better.

Two levels of recursion:

1. **Task level**: a Propose → Probe → Compose step refines the harness for the
   task you just did.
2. **Harnessing level**: lessons that the probes actually confirmed go into a
   persistent experience library (`EXPERIENCE.md`). They guide future proposals.
   Later tasks inherit the lessons, not the tuned harness.

## 0. Arguments and budget

`/harness2 [k] [parallel|sequential|quick] [focus...]`

- `k` (default 1): recursion budget. Each probe is a full re-run, so cost grows
  roughly linearly with k. Never go above k=3 without the user confirming.
- `parallel` (default): k invariant + k domain candidates, probed independently, then composed.
- `sequential`: k successive Propose→Probe→Compose steps, each starting from the previous result.
- `quick`: no probes. Propose and compose from the reference trajectory alone. Any
  lesson recorded in this mode is marked `unverified`.
- `focus`: free text that narrows the analysis (e.g. "context usage", "testing").

## 1. Locate the harness (component map)

| Harness² component | Project scope (editable directly) | Global scope |
|---|---|---|
| c1 system prompt, c2 guardrails, c3 memory, c4 tool guidance | `AGENTS.md` (or sections in it) | agent prompt files, see below |
| c5 subagents | `.opencode/agent/<name>.md` | `agent` block in `opencode.json` + `prompts/<name>.md` |
| c6 skills | `.opencode/skills/<name>/SKILL.md` | `skills/<name>/SKILL.md` |
| c7 scripts | `scripts/` in the repo | n/a |
| c8 plugins | `.opencode/plugin/<name>.ts` | `plugins` in `opencode.json` |
| commands | `.opencode/command/<name>.md` | `commands/<name>.md` |

**The global config is managed by Nix (home-manager).** Files under
`~/.config/opencode` are read-only symlinks into `/nix/store`. Check with `readlink -f`.
Never try to write there. Edit the source instead:

```
~/nixos-dotfiles/home/modules/ai/opencode/
  opencode.json   prompts/   skills/   commands/   default.nix
```

After a global edit, tell the user to run their home-manager / nixos rebuild. Don't
run it yourself unless they ask. New files must be `git add`ed, or flakes won't see them.

Prefer **project scope** unless the weakness clearly applies across repositories.

## 2. Reference execution (the trajectory)

Reconstruct what actually happened in this session, as concrete steps:

- what was read (and whether it was needed), in what order
- tool calls that were wasted, repeated, or failed, and why
- what got forgotten, assumed, or not verified (tests not run, output not re-opened,
  numbers not cross-checked)
- rework: places where the user had to correct or redirect the agent
- the final artifacts and their quality

Weaknesses must point to specific moments in the trajectory. If the session went
fine, say so and stop. **Doing nothing is a valid outcome.**

Before proposing anything, read the experience library (step 6) and note which past
lessons apply.

## 3. Propose: two kinds of candidate

For each budget slot, write:

- **Invariant edit**: fixes a general agent weakness (planning, tool use, context
  management, delegation, verification). Example: "Before reading files, list the
  directory structure and request only the relevant files."
- **Domain edit**: fixes something specific to this repository or task area
  (conventions, build quirks, domain rules). Example: "In this repo, `nix flake check`
  needs new files staged first."

Each candidate has to be:

- a **minimal diff** against one specific file from the table in step 1
- tied to the trajectory moment it addresses
- phrased as a behaviour the agent can check itself against, not a vague virtue
  ("be careful")
- small. Always-on text (AGENTS.md, agent prompts) competes for context on every
  turn, so keep each addition to a few lines. Put longer procedures into a skill with
  a trigger line instead ("When <situation>, load the `<name>` skill.").

## 4. Probe: does the edit change behaviour?

Skipped in `quick` mode.

For each candidate, re-run the task (or a representative slice of it) with the
candidate harness and compare behaviour against the reference:

1. Isolate side effects. Run probes in a throwaway git worktree, or tell the probe it
   is read-only and must not write. Probes must never push, publish, send messages,
   or touch anything outside the workspace.
2. Launch a fresh-context subagent. Give it the original task, the candidate harness
   text inlined as if it were its instructions, and the isolation rules. Tell it to
   report its trajectory (steps, files read, tool calls, checks performed) and its
   result. Probes in parallel mode are independent, so launch them concurrently.
3. Contrast the probe's trajectory with the reference. Did the targeted weakness
   disappear? Did new steps appear, or old ones vanish? Did the artifact change? Were
   there regressions (more tokens, more calls, new mistakes)?

A behavioural difference is **evidence, not proof**. An edit that merely changes
behaviour is not automatically better. Record what changed, and judge whether it
fixes the observed weakness.

## 5. Compose: accept, reject, merge

Using the reference and all probe results:

- **accept** edits whose probes removed the weakness without regressions
- **reject** edits that had no effect or made things worse
- **merge** compatible accepted edits into one coherent change, and remove duplicates
  of anything the harness already says

Present the composed change to the user as a unified diff per file, with a one-line
justification citing the probe evidence. **Apply nothing until the user approves.**
Then apply it (for global scope, to the dotfiles source) and tell them about any
rebuild needed.

In `sequential` mode, the composed harness becomes the starting point for the next step.

## 6. Reflect: update the experience library

Library: `~/.local/share/opencode/harness2/EXPERIENCE.md`. This is mutable state and
deliberately lives outside Nix. Create it with `mkdir -p` if missing.

Append only lessons that a probe contrast supports (or tag them `unverified` in
quick mode). Record rejected edits too, since knowing what didn't help is useful.
Format:

```markdown
## <YYYY-MM-DD> <short title>
- applies when: <conditions: repo type, task kind, symptom>
- edit: <what was changed, which component>
- evidence: <behavioural contrast observed> | unverified
- outcome: accepted | rejected | merged
```

Keep the library short. When a new lesson duplicates or contradicts an old one,
update the old entry instead of appending. Never store secrets, tokens, or personal
data in it.

## Guardrails

- Never modify any harness file without explicit user approval of the diff.
- Never write into `/nix/store` or into `~/.config/opencode` symlinks.
- Do not add a lesson that only the editor believes. It needs observed evidence.
- Report cost honestly. Say how many probe runs were performed.
