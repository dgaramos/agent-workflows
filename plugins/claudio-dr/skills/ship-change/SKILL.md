---
description: Claudio DR prepares and publishes a pull request for a completed implementation. Runs the final quality gate and opens the authorized PR.
---

# Claudio DR ship-change

Reviewer identity: **Claudio DR** (Claude App reviewer).

Load `core/issue-workflow/skills/ship-change/SKILL.md` and follow its
referenced contracts. Use `gh pr create` for PR creation without a second
confirmation after an explicit issue-execution request.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.
After creation, dispatch the loaded profile's `apply-pr-metadata` publisher
 mode and wait for Claudio DR's verified result. Emit a handoff if it is
 unavailable or fails; do not use a personal fallback.
