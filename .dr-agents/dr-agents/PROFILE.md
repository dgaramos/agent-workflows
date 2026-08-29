# Agent Workflows profile

Use this profile when executing workflows in this repository. Read `AGENTS.md`,
the issue, and `profiles/dr-agents.md`; run `bin/check` before handoff.

## Spec source

- **Repository:** `dgaramos/dr-specs`
- **Authorized path:** `specs/dr-agents/complete-sdd-pipeline/`

This declaration authorizes resolution of that exact trio only. It does not
authorize writing to `dgaramos/dr-specs`.

## Delivery metadata

- Labels: `enhancement` plus issue scope labels
- Milestone: `3`
- Assignee: `dgaramos`
- Project: `Agent Workflows` (`11`), status `In Progress`
- Metadata publisher: Cody `.github/workflows/publish-cody-pr-metadata.yml`;
  Claudio `.github/workflows/publish-claudio-pr-metadata.yml`

Dispatch the matching App publisher first and verify its result. If it is
unavailable or fails, an explicitly user-authorized authenticated personal
account may apply the same metadata as a fallback. Verify every field and
report that account as `personal fallback`; never represent it as Cody DR or
Claudio DR.

`Agent Workflows` #11 is a user-owned Project (`user.projectV2`), not an
organization Project. Do not request organization-Projects permission for this
operation; use the explicitly authorized personal fallback only for the
user-owned Project step when the App cannot perform it.
