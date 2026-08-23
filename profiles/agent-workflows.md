# Agent Workflows profile

Use this profile when reviewing this repository. Read `AGENTS.md`, `README.md`,
`CONTRIBUTING.md`, the issue, changed plugin manifests, both adapter skills, and
their review contracts. Run `bin/check` before handoff.

## Publication contract

Use `core/pr-review/references/reviewer-identity-contract.md`. Cody DR, the
Cody DR GitHub App, and `cody-dr[bot]` are one reviewer identity; Claudio DR,
the Claudio DR GitHub App, and `claudio-dr[bot]` are likewise one identity.

Publication is always explicitly authorized. The local publisher configuration
is discovered from repository variables and secrets by name only: Cody uses
`CODY_DR_CLIENT_ID` and `CODY_DR_PRIVATE_KEY`; Claudio uses
`CLAUDIO_DR_CLIENT_ID` and `CLAUDIO_DR_PRIVATE_KEY`. Never read, print, copy,
or commit their values.

The target publisher must use an installation token, publish as the matching
GitHub App, then verify its author, event, and target PR/thread. It needs Pull
requests read/write for reviews and replies, and Issues read/write for resolving
conversations and creating issues. If no target publisher documents the
requested mode, return publication-ready text as `not published`.

## Cody DR publisher modes

- `review`: `.github/workflows/publish-cody-review.yml`
- `reply`: `.github/workflows/publish-cody-review.yml`
- `resolve-thread`: `.github/workflows/publish-cody-review.yml`
- `create-issue`: `.github/workflows/publish-cody-issue.yml`

The review publisher accepts a reviewed head SHA plus an optional review body,
inline findings, thread replies, and thread resolutions. A profile that lacks one of those modes
must report only that operation as unavailable, rather than claiming that the
Cody DR App is inactive.

Issue creation is dispatched with a title, Markdown body, and optional labels,
assignees, and milestone number. The workflow must verify the created author is
`cody-dr[bot]`; a different author is a failed publication, not a fallback.

## Claudio DR publisher modes

- `review`: `.github/workflows/publish-claudio-review.yml`
- `reply`: `.github/workflows/publish-claudio-review.yml`
- `resolve-thread`: `.github/workflows/publish-claudio-review.yml`
- `create-issue`: `.github/workflows/publish-claudio-issue.yml`

The review publisher accepts a reviewed head SHA plus an optional review body,
inline findings, thread replies, and thread resolutions. Missing modes follow the same
unavailable-operation behavior; their absence does not indicate an inactive
Claudio DR App.

Issue creation follows the same inputs and verification requirement, with
`claudio-dr[bot]` as the expected author.

## Boundaries

Keep portable behavior in `core/`, model mechanics in `plugins/`, and this
repository's operational integration in `profiles/`. Do not add credentials,
automatic publication, or target-project rules to the shared contract.
