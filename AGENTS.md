# Agent Workflows instructions

## Purpose

Maintain a reusable catalog of cross-model agent workflows. The
catalog supports Codex and Claude Code without making either implementation the
source of truth for portable behavior.

## Boundaries

- Keep `core/` free of target-project architecture, commands, credentials,
  issue metadata, and deployment assumptions.
- Put agent-specific invocation, packaging, and identity in `plugins/`.
- Put project rules, tests, commands, and architecture in `profiles/`.
- Never commit private keys, access tokens, passwords, local settings, cloned
  target projects, or generated credentials.
- Do not introduce automatic PR review, GitHub Actions review triggers, or
  publication by default unless an issue explicitly authorizes that scope.

## Quality

- Keep the Codex and Claude adapters behaviorally equivalent where the portable
  contract applies; document intentional platform differences.
- Add a generic example whenever a core contract changes.
- Run `bin/check` before handoff.

## Delivery

- Use a dedicated branch and pull request for each issue.
- Use Conventional Commits.
- Link PRs to their issue and preserve issue labels, milestone, assignee, and
  Project metadata.
