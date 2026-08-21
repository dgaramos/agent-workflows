---
description: Claudio DR triages actionable pull request findings, applies valid in-scope fixes, validates them, and prepares or publishes thread updates only when explicitly authorized.
---

# Claudio DR findings

Reviewer identity: **Claudio DR** (Claude App reviewer).

Verify every finding against the current head before acting. Classify it as fix
now, defer, or reject. Keep a fix within the PR's scope; create a separate
issue for a valid out-of-scope request.

For each accepted finding, make the minimal correction, run the profile's
quality command, and keep the commit logically isolated. Do not publish a
reply, resolve a thread, push, or merge unless the user explicitly authorizes
that external action.

When authorized to publish, use the publisher documented in the target profile
per the dispatch and reply contracts in `core/pr-review/references/profile-contract.md`.
Verify that every reply and resolution is authored by Claudio DR in the intended
thread per the post-publication verification requirements in
`core/pr-review/references/review-contract.md`. Never mark a finding resolved
based only on a reply.
