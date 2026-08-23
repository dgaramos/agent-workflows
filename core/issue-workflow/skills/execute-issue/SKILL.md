---
name: execute-issue
description: Orchestrate the full issue-to-change lifecycle: start-issue, implement-issue, and ship-change in sequence, including normal delivery publication.
---

# Portable execute-issue

Load [workflow-contract](../../references/workflow-contract.md) and
[execute-issue-contract](../../references/execute-issue-contract.md) before
acting. They define the orchestration sequence, authorization boundary, profile
loading rules, handoff format, and final summary output.

Load the target project's profile once at start and pass its context through
all phases. An explicit issue-execution request authorizes normal lifecycle
delivery actions; do not ask for a second confirmation.
