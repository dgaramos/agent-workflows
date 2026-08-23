---
name: implement-issue
description: Implement the changes required by an issue on the working branch. Makes minimal in-scope changes, runs quality gates after each logical unit, and commits in isolation.
---

# Portable implement-issue

Load [workflow-contract](../../references/workflow-contract.md) and
[implement-issue-contract](../../references/implement-issue-contract.md) before
acting. They define profile-owned fields, the quality gate, the publication
boundary, the handoff format, and the implement-issue steps and output.

Require a confirmed working branch and issue context from `start-issue`. Stop
and emit a handoff block if the quality command fails or any acceptance
criterion cannot be addressed within the stated scope.
