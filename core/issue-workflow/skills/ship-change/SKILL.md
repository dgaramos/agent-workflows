---
name: ship-change
description: Prepare and publish a pull request for a completed implementation. Runs the final quality gate, applies profile metadata, and pushes and opens the PR only when explicitly authorized.
---

# Portable ship-change

Load [workflow-contract](../../references/workflow-contract.md) and
[ship-change-contract](../../references/ship-change-contract.md) before acting.
They define profile-owned fields, the quality gate, the publication boundary,
the handoff format, and the ship-change steps and output.

Require a passing quality gate before preparing the PR. Do not push or create
the PR without explicit user authorization. Return the prepared PR as
`not published` if authorization is not given.
