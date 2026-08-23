---
name: execute-issue
description: Orchestrate the full issue-to-change lifecycle: start-issue, implement-issue, and ship-change in sequence, including normal delivery publication.
---

# Portable execute-issue

Load [workflow-contract](../../references/workflow-contract.md) and
[execute-issue-contract](../../references/execute-issue-contract.md) before
acting. They define the orchestration sequence, the authorization boundary
(no implicit pre-authorization of external actions), profile loading rules,
the handoff format, and the final summary output.

Load the target project's profile once at start and pass its context through
all phases. An explicit issue-execution request authorizes push and PR
creation; do not ask for a second confirmation.
