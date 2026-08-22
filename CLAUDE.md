# CLAUDE.md

## What this repo is

Private catalog of reusable, cross-model agent workflows. Behavior is defined
in `core/`, consumed by thin adapter plugins, and tuned per project through
profiles. This is the source of truth for Claudio DR (Claude Code) and Cody DR
(Codex) review, findings-handling, issue-authoring, and lifecycle skills.

## Structure and boundaries

```text
core/                    Portable contracts — never touch target-project specifics here
plugins/claudio-dr/      Claude Code adapter — identity and platform mechanics only
plugins/cody-dr/         Codex adapter — identity and platform mechanics only
profiles/                Project profiles — architecture, commands, metadata, publishers
examples/                One generic example per core skill area
docs/                    Compatibility, installation, development docs
bin/check                Catalog quality gate — run before every handoff
```

**Core** contains only portable, model-neutral contracts. Do not add
repository-specific commands, credentials, labels, branch names, or remote
references to any file under `core/`.

**Adapters** contain only reviewer identity and platform-specific invocation.
Do not embed portable contract content (finding tables, confidence thresholds,
summary templates) in adapter SKILL.md files — reference the core file by path.

**Profiles** contain everything project-specific. They strengthen the core;
they never weaken the evidence threshold or the explicit-publication boundary.

## Architecture

Read [docs/architecture.md](docs/architecture.md) for the full layer diagram,
data flow, publication model, and how `bin/check` enforces layer boundaries.
The short version: `core/` → contracts, `plugins/` → identity + platform,
`profiles/` → project rules.

## Quality gate

Before every commit or handoff:

```bash
bin/check
```

This verifies required paths, SKILL.md frontmatter, adapter drift, parity
between Claudio and Cody adapters, and the absence of tracked secrets.

## Commit style

Conventional Commits:

```text
type(scope): description
```

Allowed types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `build`, `ci`.
Scope examples: `review`, `workflow`, `profile`, `claude`, `codex`, `core`.

## Working on issues

One branch and one PR per issue. Name branches `<issue-number>-<type>/<slug>`.
Link PRs to their issue. Preserve labels, milestone, assignee, and Project
board status.

## Adding a core skill

1. Create `core/<area>/SKILL.md` and `core/<area>/references/<contract>.md`.
2. Add a generic example under `examples/`.
3. Add thin adapter skills in both `plugins/claudio-dr/` and `plugins/cody-dr/`
   that reference the core skill by path.
4. Add all new paths to `required_paths` in `bin/check`.
5. Add parity and drift checks to `bin/check` as needed.
6. Run `bin/check` — it must pass before opening the PR.

## Adding a profile

1. Create `profiles/<project>.md` following the profile-contract at
   `core/pr-review/references/profile-contract.md`.
2. Include: project identity, required context, architecture boundaries,
   quality command, skill mapping, PR metadata rules, and publisher dispatch
   contract (modes, secret names only — never values).
3. Add the path to `required_paths` in `bin/check`.

## Publication safety

All external actions — reviews, replies, thread resolution, issue creation,
push, PR creation — require explicit user authorization. Never infer
authorization from context or a prior phase. Never store or read credentials;
reference secret names only. Return publication-ready output as `not published`
when no publisher is configured or authorization is absent.

## Never do

- Hardcode branch names, labels, commands, or remotes in `core/`.
- Duplicate contract content across adapters — reference the core file.
- Commit credentials, tokens, private keys, or installation tokens.
- Publish, push, or merge without explicit user authorization.
- Skip `bin/check` before handoff.
