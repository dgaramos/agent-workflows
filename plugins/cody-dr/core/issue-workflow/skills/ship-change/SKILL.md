---
name: ship-change
description: Prepare and publish a fully populated pull request for a completed implementation as a normal issue-execution action.
---

# Portable ship-change

Load [workflow-contract](../../references/workflow-contract.md) and
[ship-change-contract](../../references/ship-change-contract.md) before acting.
They define profile-owned fields, the quality gate, the publication boundary,
the handoff format, and the ship-change steps and output.

Require a passing quality gate before preparing the PR. The explicit
issue-execution request authorizes pushing and creating the PR; do not seek a
second confirmation.

After creating the PR, invoke
`core/issue-workflow/scripts/apply-pr-metadata.sh` with the profile's declared
metadata. Do not manually substitute partial `gh pr edit` calls: the helper
also verifies each configured field and must succeed before handoff.
