---
name: ship-change
description: Cody DR prepares and publishes a pull request for a completed implementation. Runs the final quality gate and opens the authorized PR.
---

# Cody DR ship-change

Reviewer identity: **Cody DR** (Codex App reviewer).

Load `core/issue-workflow/skills/ship-change/SKILL.md` and follow its
referenced contracts. Use `gh pr create` for PR creation without a second
confirmation after an explicit issue-execution request.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.

Follow `core/issue-workflow/references/contribution-guidance-contract.md` to
apply PR-body and delivery-metadata guidance from `CONTRIBUTING.md`. A missing
file is not a blocker; surface any material conflict with the profile before
opening the PR.

After creation, dispatch the loaded profile's `apply-pr-metadata` publisher
 mode and wait for Cody DR's verified result. If it is unavailable or fails,
 use a personal fallback only with explicit user authorization and report that
 account; never represent it as Cody DR.
