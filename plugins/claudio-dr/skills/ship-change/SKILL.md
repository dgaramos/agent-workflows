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
After creation, invoke `core/issue-workflow/scripts/apply-pr-metadata.sh` with
the loaded profile values. It applies and verifies labels, milestone,
assignees, reviewers, Project state, and the base branch; emit a handoff on
failure.
