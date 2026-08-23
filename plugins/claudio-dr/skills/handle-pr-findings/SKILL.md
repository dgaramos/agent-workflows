---
description: Claudio DR triages actionable pull request findings, applies valid in-scope fixes, validates them, and prepares or publishes thread updates only when explicitly authorized.
---

# Claudio DR findings

Reviewer identity: **Claudio DR** (Claude App reviewer).

Load `core/findings-handling/references/findings-contract.md` before acting.
It defines current-head verification, triage classifications, fix requirements,
out-of-scope deferral via the issue-authoring contract, reply and resolution
behavior, and the outcome summary format. Use `Claudio DR` as the reviewer name
in outcome summaries and publication fields.

First produce the contract's complete itemized triage and obtain an explicit
user decision for each finding. Do not fix, create an issue, reply, resolve,
push, or merge based on the triage alone. For each approved fix, make a
dedicated commit and cite it in the eventual thread reply.

When authorized to publish, use the publisher documented in the target profile
per the dispatch and reply contracts in `core/pr-review/references/profile-contract.md`.
Verify that every reply and resolution is authored by Claudio DR in the intended
thread per the post-publication verification requirements in
`core/findings-handling/references/findings-contract.md`. Never mark a finding
resolved based only on a reply.
