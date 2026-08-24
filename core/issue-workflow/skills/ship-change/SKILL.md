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

When the loaded profile declares a PR template, use it as the PR body shape.
Retain every heading and fill each section with change-specific information or
`Not applicable`; do not replace the template with a short generic summary.

After creating the PR, dispatch the loaded profile's `apply-pr-metadata`
publisher workflow via `gh workflow run`, passing every profile-declared
metadata field as a workflow input. This step is mandatory when the profile
declares any metadata fields; skip only when the profile declares none. Wait
for the run to complete and verify the bot identity and all declared fields.
If the publisher is unavailable or fails, use a personal `gh` fallback only
with explicit user authorization; verify all fields and name that account in
the result. Never represent the fallback as the reviewer App.
