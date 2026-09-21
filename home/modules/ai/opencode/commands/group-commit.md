---
description: Group current changes by theme and create clean commits
---

Review all current uncommitted changes in the repository and organize them into logical commits by theme.

Requirements:
1. Inspect the full working tree:
    - git status
    - git diff
    - git diff --staged
    - relevant file history if needed
2. Understand what each change does before grouping it.
3. Group changes by logical purpose/theme, not simply by file or chronology.
   Examples:
    - feature implementation
    - bug fix
    - refactoring
    - configuration/build changes
    - tests
    - documentation
4. Do NOT discard, revert, or modify the intended code changes just to make the commits cleaner.
5. If a single file contains changes belonging to different themes, split those changes appropriately using interactive staging (`git add -p`, `git restore --staged`, etc.).
6. Create separate, focused commits with clear conventional commit messages.
7. Avoid mixing unrelated changes in the same commit.
8. Preserve dependencies between changes: if one change logically depends on another, order the commits accordingly.
9. Determine the commit groups yourself and immediately create the commits.

Important:
- Do not push anything.
- Do not amend existing commits.
- Do not reset or lose any work.
- Do not create a commit for changes that are genuinely unrelated unless they cannot reasonably be separated.
- If something is ambiguous, ask me before committing.

Goal: turn the current messy working tree into a clean sequence of small, logically grouped commits.