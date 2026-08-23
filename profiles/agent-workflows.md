# Agent Workflows profile

Use this profile when reviewing this repository. Read `AGENTS.md`, `README.md`,
`CONTRIBUTING.md`, the issue, changed plugin manifests, both adapter skills, and
their review contracts. Run `bin/check` before handoff.

## Claudio DR self-review

Use Claudio DR's `review-pr` skill (or the `claudio-reviewer` agent) against an
explicit pull request URL. In the review request, name this profile explicitly:

```text
Review <PR URL> with Claudio DR using the agent-workflows profile at
profiles/agent-workflows.md.
```

Before reviewing, Claudio DR must load this profile and read `CLAUDE.md`, the
issue and pull-request context, every changed skill and its referenced portable
contract, plus `bin/check` output for the reviewed head. Apply the catalog
checklist: keep portable behavior in `core/`, keep model-specific mechanics in
`plugins/`, keep target-project rules in `profiles/`, preserve Codex/Claude
adapter parity where the portable contract applies, require a generic example
for a core-contract change, and reject any credential or implicit-publication
change. Publish a review only with explicit authorization, through the Claudio
DR publisher, and verify the resulting author is `claudio-dr[bot]`.

## PR metadata

- **Labels:** `enhancement` plus scope labels selected by the issue
- **Milestone:** `3`
- **Assignee:** `dgaramos`
- **Project:** `Agent Workflows` (`11`), status `In Progress` while active
- **Reviewers:** only when explicitly requested

After shipping, apply and verify every declared field. Do not silently omit a
field because a CLI command or permission failed.

Invoke `core/issue-workflow/scripts/apply-pr-metadata.sh` with `--base main`,
the selected labels, `--milestone 3`, `--assignee dgaramos`, and
`--project-owner dgaramos --project-number 11 --project-status "In Progress"`.
Reviewers remain absent unless explicitly requested.

## PR description

Use [`.github/pull_request_template.md`](../.github/pull_request_template.md).
Retain every section and fill it with the change-specific answer; mark a
section `Not applicable` rather than deleting it. The `What changes` section
explains the intent and workflow impact, not a diff inventory. Include
`Closes #<issue-number>` in Additional context.

## Publication contract

Use `core/pr-review/references/reviewer-identity-contract.md`. Cody DR, the
Cody DR GitHub App, and `cody-dr[bot]` are one reviewer identity; Claudio DR,
the Claudio DR GitHub App, and `claudio-dr[bot]` are likewise one identity.

An explicit issue-execution request authorizes its normal delivery, including
branch creation, commits, push, PR creation, and complete PR metadata. Review,
comment, reply, resolution, and issue-creation publication remain separately
authorized. The local publisher configuration is
discovered from repository variables and secrets by name only: Cody uses
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
- `apply-pr-metadata`: `.github/workflows/publish-cody-pr-metadata.yml`
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

## Explicit review requests

The PR template lets contributors request Cody DR, Claudio DR, or no agent
review. It is a collaboration signal, not an automation trigger: an authorized
model executor must still be explicitly asked to review the PR and may dispatch
the matching publisher only after preparing a verified manifest. The checkbox
never authorizes approval, merge, issue creation, or issue execution.

Use the same request shape for both reviewers. The only differences are the
adapter identity and its publisher workflow.

## Fallback reviewer

Use a local, user-authorized reviewer only when **neither** Cody DR nor Claudio
DR is configured for the target repository. If either App is configured, use
that App's matching publisher; never silently replace it with a personal
account or a different bot. The fallback may analyze the PR and, only with
explicit authorization, publish as the authenticated user while clearly naming
that actor in the review summary. It must never claim to be Cody DR or Claudio
DR.

Neither App submits `REQUEST_CHANGES`. Findings are published as a `COMMENT`;
whether they block merging is decided by a human reviewer.

## Claudio DR publisher modes

- `review`: `.github/workflows/publish-claudio-review.yml`
- `apply-pr-metadata`: `.github/workflows/publish-claudio-pr-metadata.yml`
- `reply`: `.github/workflows/publish-claudio-reply.yml`
- `resolve-thread`: `.github/workflows/publish-claudio-resolve.yml`
- `create-issue`: `.github/workflows/publish-claudio-issue.yml`

The review publisher accepts a reviewed head SHA plus an optional review body and
inline findings. The dedicated thread publishers verify that the GraphQL review-thread
ID belongs to the supplied pull request before replying or resolving it; reply
publication additionally verifies `claudio-dr[bot]` as the author. Missing modes follow the same
unavailable-operation behavior; their absence does not indicate an inactive
Claudio DR App.

Issue creation follows the same inputs and verification requirement, with
`claudio-dr[bot]` as the expected author.

## Boundaries

Keep portable behavior in `core/`, model mechanics in `plugins/`, and this
repository's operational integration in `profiles/`. Do not add credentials,
automatic publication, or target-project rules to the shared contract.
