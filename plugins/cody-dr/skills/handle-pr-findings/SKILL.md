---
name: handle-pr-findings
description: Cody DR triages actionable pull request findings, applies valid in-scope fixes, validates them, and prepares or publishes thread updates only when explicitly authorized.
---

# Cody DR findings

Verify every finding against the current head before acting. Classify it as fix
now, defer, or reject. Keep a fix within the PR's scope; create a separate
issue for a valid out-of-scope request.

For each accepted finding, make the minimal correction, run the profile's
quality command, and keep the commit logically isolated. Do not publish a
reply, resolve a thread, push, or merge unless the user explicitly authorizes
that external action. Never mark a finding resolved based only on a reply.
