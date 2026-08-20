# Contributing

## Scope discipline

Classify every change before editing:

| Location | Responsibility |
| --- | --- |
| `core/` | Model-neutral protocol, schema, and examples |
| `plugins/codex/` | Codex packaging and Cody DR mechanics |
| `plugins/claude/` | Claude Code packaging and Claudio DR mechanics |
| `profiles/` | Target-project rules and integration guidance |

Do not solve a project-specific problem by changing `core/` unless the behavior
is demonstrably portable.

## Versioning

Use semantic versions for distributable plugins. A release must record:

- compatible Codex or Claude Code version when relevant;
- the core contract version it consumes;
- migration or reinstall steps for an incompatible change.

Do not publish a plugin release that changes behavior without a version update.

## Security

Plugins and profiles may describe how an external publisher is configured, but
must not contain its private key, token, installation token, or secret. A
reviewer without a publisher returns comments ready for the user to publish.

## Pull requests

Use `type(scope): imperative summary` and include `Closes #<issue>` in the
description. Run `bin/check` and explain the affected layer, compatibility,
installation impact, and whether a profile or adapter changes.

Every issue and pull request has an assignee, label, milestone, and Project
item. Use a feature branch from `main`; do not push feature work directly to
the default branch.

The current GitHub plan does not support branch protection for this private
repository. Until that changes, treat a passing `quality` GitHub Actions run
and review of the PR checklist as mandatory before merging.
