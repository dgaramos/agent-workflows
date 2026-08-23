# Agent Workflows profile

Use this profile when reviewing this repository. Read `AGENTS.md`, `README.md`,
`CONTRIBUTING.md`, the issue, changed plugin manifests, both adapter skills, and
their review contracts. Run `bin/check` before handoff.

## Publication contract

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

- `review`, `reply`, and `resolve-thread`: `.github/workflows/publish-cody-review.yml`
- `create-issue`: `.github/workflows/publish-cody-issue.yml`

Issue creation is dispatched with a title, Markdown body, and optional labels,
assignees, and milestone number. The workflow must verify the created author is
`cody-dr[bot]`; a different author is a failed publication, not a fallback.

## Boundaries

Keep portable behavior in `core/`, model mechanics in `plugins/`, and this
repository's operational integration in `profiles/`. Do not add credentials,
automatic publication, or target-project rules to the shared contract.
