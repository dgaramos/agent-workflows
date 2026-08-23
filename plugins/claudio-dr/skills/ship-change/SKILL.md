---
description: Claudio DR prepares and publishes a pull request for a completed implementation. Runs the final quality gate and opens the PR only when explicitly authorized.
---

# Claudio DR ship-change

Reviewer identity: **Claudio DR** (Claude App reviewer).

Load `core/issue-workflow/skills/ship-change/SKILL.md` and follow its
referenced contracts. Use `gh pr create` for PR creation when authorized.
Apply profile-required metadata via `gh pr edit` after creation and verify
the PR targets the profile's base branch. Apply and verify labels, milestone,
assignees, reviewers, and Project state individually; emit a handoff on failure.
