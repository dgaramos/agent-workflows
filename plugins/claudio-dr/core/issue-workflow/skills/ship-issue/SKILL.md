---
name: ship-issue
description: Run final validation and ship an explicitly approved implementation.
---

# Portable ship-issue

Load `../../references/ship-issue-contract.md`. When reached via an explicit issue-execution request, push and open the PR directly — the plan approval already authorized this step. Only require explicit approval when `ship-issue` is invoked standalone, outside an `execute-issue` lifecycle.
