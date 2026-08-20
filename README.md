# Agent Workflows

Private, versioned workflows for reviewing pull requests across Codex and Claude
Code. The catalog keeps reusable review behavior separate from each project's
architecture, commands, security rules, and publishing configuration.

## Design

```text
core/                 Portable protocols and reporting contracts
plugins/codex/        Cody DR distribution for Codex
plugins/claude/       Claudio DR distribution for Claude Code
profiles/             Explicit project-specific adapters
examples/             Generic, safe usage examples
docs/                 Compatibility, development, and release guidance
```

The core is model-neutral. Plugins own invocation, identity, and platform
mechanics. A profile augments the core with a target repository's rules; it
never moves those rules into the shared workflow.

## Current roadmap

1. Establish this catalog and its release rules.
2. Extract a portable PR review, re-review, and reporting contract.
3. Package the Cody DR and Claudio DR adapters.
4. Use CraftControl as the first project profile.

See the [Agent Workflows Project](https://github.com/users/dgaramos/projects/11)
for the delivery board.

## Safety

- Workflows never publish a GitHub review without explicit user authorization.
- The repository never stores GitHub App private keys, tokens, passwords, or
  target-project secrets.
- A missing publisher produces publication-ready text rather than a credential
  lookup or an unsafe fallback.
- Project profiles remain authoritative for their own quality gates and rules.

## Development

Read [development](docs/development.md), [compatibility](docs/compatibility.md),
and [contributing](CONTRIBUTING.md). Run `bin/check` before opening a pull
request. GitHub Actions runs the same `quality` check for pull requests and
pushes to `main`.

## Install and use

Install the private marketplace adapter you need:

- [Cody DR for Codex](docs/cody-dr.md)
- [Claudio DR for Claude Code](docs/claudio-dr.md)

For CraftControl, explicitly select the
[CraftControl profile](docs/craftcontrol-profile.md). Its repository-native
review skills remain available as a fallback during adoption.
