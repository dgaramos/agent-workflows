# CraftControl review profile

Use this profile only for the `dgaramos/craftcontrol` repository. It strengthens
the portable PR review contract; the core evidence threshold, explicit input,
and explicit publication boundary still apply.

## Required context

Before planning, reviewing, or changing CraftControl, read `README.md`, every
Markdown file in its local `roadmap/` directory, `AGENTS.md`, and
`CONTRIBUTING.md`. The roadmap is private operational context: never stage,
quote, publish, or copy it into this catalog or review output. Read
`docs/architecture.md` for architecture, persistence, runtime, or
infrastructure changes.

## Review scope

Load every matching checklist before concluding:

| Changed boundary | Checklist |
| --- | --- |
| `apps/backend/` or `tests/` | [backend](references/backend.md) |
| `apps/frontend/static/js/` or `apps/frontend/tests/` | [frontend](references/frontend.md) |
| OpenAPI, HTTP routes, or generated declarations | [contracts](references/contracts.md) |
| `packs/telemetry/`, `bin/`, Compose, Docker, deploy, backup, or restore | [operations](references/operations.md) |
| `README`, Markdown, `CONTRIBUTING`, or `AGENTS` | [contribution](references/contribution.md) |

Always assess compatibility, persistence, authorization, player data, and
backup/recovery when they apply. Review changed code with callers, tests, and
its public contract; do not infer behavior from a diff alone.

## Quality and contribution rules

Run `bin/check` before handoff when modifying CraftControl. Its independent
gates are `bin/check-frontend`, `bin/check-backend`, `bin/check-contracts`,
and `bin/check-integration`; keep a test in exactly one gate unless it spans a
deliberate boundary. Require English `README.md` and tests to change with
public behavior, persistence, recovery, configuration, or API contracts.

CraftControl contributions use an issue branch, Conventional Commits, and a PR
with Project, Milestone, Label, and Assignee. CodeRabbit findings are reviewed
and addressed before merge. Never include roadmap content, `.env`, databases,
world data, credentials, or private keys.

## Reviewer identity and publication

Codex reviews are attributed to **Cody DR** and Claude Code reviews to
**Claudio DR**. Their optional GitHub App publishers are `cody-dr` and
`claudio-dr`. A publisher is optional: without explicit user authorization and
a configured publisher, return publication-ready content marked `not
published`. When a reviewer authors a CraftControl commit, use its matching
co-author trailer: `Cody DR <dgaramos+cody@gmail.com>` or `Claudio DR
<dgaramos+claudio@gmail.com>`.

## Adoption and fallback

Select this profile explicitly when invoking the portable Cody DR or Claudio
DR reviewer. CraftControl's repository-native `review-pr` entry points remain
authoritative during migration and are the fallback if this profile or an
adapter is unavailable. This profile never causes an automatic review.
