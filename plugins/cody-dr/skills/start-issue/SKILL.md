---
name: start-issue
description: Cody DR begins the issue-to-change lifecycle. Loads the profile, resolves the issue, checks dependencies, and creates the working branch.
---

# Cody DR start-issue

Reviewer identity: **Cody DR** (Codex App reviewer).

Load `core/issue-workflow/skills/start-issue/SKILL.md` and follow its
referenced contracts. Use Codex shell and file tools for branch creation as
documented in the target profile's platform notes, if any.

**Platform-specific detail (Codex only):** the shell and file tools instruction
above is scoped to the Codex platform. It is intentionally not mirrored in the Claudio DR adapter, which uses Claude Code worktree mechanics for the same step.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.
