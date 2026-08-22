# Agent Workflows

Private catalog of reusable, cross-model agent workflows for reviewing pull
requests, handling findings, authoring issues, and driving the full
issue-to-change lifecycle. Behavior is defined once in `core/`, consumed by
Codex and Claude Code adapters, and tuned per project through profiles.

## Structure

```text
core/                         Portable contracts (review, findings, issue authoring, lifecycle)
plugins/claudio-dr/           Claudio DR adapter for Claude Code
plugins/cody-dr/              Cody DR adapter for Codex
profiles/                     Project-specific profiles (CraftControl, agent-workflows, …)
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

Invoke a review:

```text
/claudio-dr:review-pr <PR URL or ref>
/claudio-dr:review-pr <PR URL> using profiles/craftcontrol.md
```

See [docs/claudio-dr.md](docs/claudio-dr.md) for the full installation,
update, and local validation flow.

## Install Cody DR (Codex)

```bash
codex plugin marketplace add /path/to/agent-workflows
codex plugin add cody-dr@agent-workflows
```

Invoke a review:

```text
@cody-reviewer review <PR URL or ref>
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
| `implement-issue` | Make minimal in-scope changes with quality-gate validation |
| `ship-change` | Run final quality gate, prepare PR with profile metadata, push when authorized |
| `execute-issue` | Orchestrate the full start → implement → ship lifecycle |

All publication actions (reviews, replies, thread resolution, issue creation,
push, PR creation) require explicit user authorization. Without a configured
publisher, every skill returns publication-ready output as `not published`.

## Profiles

| Profile | Target |
| --- | --- |
| `profiles/agent-workflows.md` | This repository |
| `profiles/craftcontrol.md` | CraftControl |

Add a profile for any repository that needs architecture-specific review rules,
custom quality commands, or bot publication configured.

## Safety

- Workflows never publish without explicit user authorization.
- The repository never stores GitHub App keys, tokens, or target-project
  secrets. Publisher configuration references secret names only.
- A missing publisher returns publication-ready text rather than a credential
  lookup or silent fallback.
- Project profiles strengthen the core; they cannot weaken evidence thresholds
  or the explicit-publication boundary.

## Development

Read [development](docs/development.md), [compatibility](docs/compatibility.md),
and [contributing](CONTRIBUTING.md). Run `bin/check` before opening a pull
request. GitHub Actions runs the same `quality` check on every PR and push to
`main`.

See the [Agent Workflows Project](https://github.com/users/dgaramos/projects/11)
for the delivery board.
