---
name: execute-issue
description: Cody DR orchestrates the full issue-to-change lifecycle: start-issue, implement-issue, and ship-change in sequence with authorized normal delivery.
---

# Cody DR execute-issue

Reviewer identity: **Cody DR** (Codex App reviewer).

Load `core/issue-workflow/skills/execute-issue/SKILL.md` and follow its
referenced contracts. An explicit issue-execution request authorizes push and
PR creation; do not ask for a second confirmation at the ship-change phase.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.
