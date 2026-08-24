# Agent Workflows

Reusable, cross-model catalog of agent workflows for reviewing pull
requests, handling findings, authoring issues, and driving the full
issue-to-change lifecycle. Behavior is defined once in `core/`, consumed by
Codex and Claude Code adapters, and tuned per project through profiles.

## Structure

```text
core/                         Portable contracts (review, findings, issue authoring, lifecycle)
plugins/claudio-dr/           Claudio DR adapter for Claude Code
plugins/cody-dr/              Cody DR adapter for Codex
profiles/                     This catalog's self-profile and a generic profile example
examples/                     Generic, safe usage examples for each core skill
docs/                         Compatibility, development, and release guidance
bin/check                     Catalog quality gate
```

The core is model-neutral. Adapters own invocation, identity, and platform
mechanics. A profile supplies project rules — architecture, commands, metadata,
remotes, and publisher configuration — without touching the shared contracts.

## Install Claudio DR (Claude Code)

```text
/plugin marketplace add dgaramos/agent-workflows
/plugin install claudio-dr@agent-workflows
```

Use a workflow agent or invoke an installed skill directly:

```text
/claudio-dr:review-pr <PR URL or ref>
/claudio-dr:review-pr <PR URL> using a profile from the target repository
/claudio-dr:execute-issue #42
/claudio-dr:author-issue <structured issue request>
```

See [docs/claudio-dr.md](docs/claudio-dr.md) for the full installation,
update, and local validation flow.

## Install Cody DR (Codex)

```bash
codex plugin marketplace add /path/to/agent-workflows
codex plugin add cody-dr@agent-workflows
```

Use a workflow agent or invoke an installed skill directly:

```text
@cody-reviewer review <PR URL or ref>
@cody-workflow execute issue #42
@cody-workflow plan issue #42
@cody-helper explain how to use Cody DR in this repository
```

See [docs/cody-dr.md](docs/cody-dr.md) for the full installation and local
validation flow.

## Available skills

| Skill | What it does |
| --- | --- |
| `review-pr` | Evidence-first PR review with incremental re-review |
| `handle-pr-findings` / `handle-findings` | Triage, fix, defer, or reject findings against the current head |
| `author-issue` | Draft and optionally publish a structured GitHub issue |
| `start-issue` | Load a profile and issue, check dependencies, create working branch |
| `plan-implementation` | Print a read-only, test-first implementation plan before edits |
| `implement-issue` | Make minimal in-scope changes with quality-gate validation |
| `ship-change` | Run final quality gate, prepare PR with profile metadata, then push and open it |
| `execute-issue` | Orchestrate the full start → implement → ship lifecycle |

An explicit issue-execution request authorizes the normal delivery path:
branch, implementation, validation, commits, push, and a complete PR. Reviews,
replies, thread resolution, and issue creation remain separately authorized.
For finding replies and thread resolutions, a configured reviewer App is used
and verified first. An explicitly authorized authenticated personal account may
publish only when that App operation is unavailable before dispatch; failed App
publication or verification never silently falls back. Otherwise,
publisher-backed actions return publication-ready output as `not published`.

Both plugins provide the same portable capabilities. Their differences are
platform invocation, agent identity, and plugin update commands; project
architecture, quality commands, metadata, and publishers come from an optional
profile in the target repository.

`execute-issue` always plans before it edits. Plans map each executable change
to Red → Green → Refactor coverage; non-executable work states why TDD is not
applicable and names its strongest structural validation.

## Profiles

| Profile | Target |
| --- | --- |
| `profiles/agent-workflows.md` | This repository |
| `profiles/example-project.md` | Neutral template for a consumer project |

The catalog ships only its self-profile and a neutral example. A consumer keeps
its actual profile in its own repository, where it can define
architecture-specific review rules, custom quality commands, and bot
publication configuration without exposing those details here.

## Lifecycle example

Read the [generic issue-to-change lifecycle](examples/generic-issue-lifecycle.md)
for a profile-neutral walkthrough of dependency handling, incremental quality
gates, shipping, and handoffs.

## Safety

- Issue execution publishes its normal delivery only when explicitly requested;
  reviews, comments, replies, and thread resolution always need separate
  authorization.
- The repository never stores GitHub App keys, tokens, or target-project
  secrets. Publisher configuration references secret names only.
- A missing publisher returns publication-ready text rather than a credential
  lookup or silent fallback.
- Project profiles strengthen the core; they cannot weaken evidence thresholds
  or the explicit-publication boundary.

## Development

Read [architecture](docs/architecture.md), [compatibility](docs/compatibility.md),
[development](docs/development.md), and [contributing](CONTRIBUTING.md). Run
`bin/check` before opening a pull request. GitHub Actions runs the same
`quality` check on every PR and push to `main`.

See the [Agent Workflows Project](https://github.com/users/dgaramos/projects/11)
for the delivery board.
