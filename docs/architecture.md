# Architecture

## Overview

The catalog is organized in three independent layers. Each layer has a single
responsibility and a strict boundary — no layer reaches into the one above it.

```
┌─────────────────────────────────────────────────────────────────┐
│                          PROFILES                               │
│  Project-specific: architecture, commands, metadata, publishers │
│  profiles/agent-workflows.md   profiles/craftcontrol.md   …    │
└────────────────────────┬────────────────────────────────────────┘
                         │ loads
┌────────────────────────▼────────────────────────────────────────┐
│                          ADAPTERS                               │
│  Platform invocation + reviewer identity, no portable content   │
│  plugins/claudio-dr/   (Claude Code)                            │
│  plugins/cody-dr/      (Codex)                                  │
└────────────────────────┬────────────────────────────────────────┘
                         │ references
┌────────────────────────▼────────────────────────────────────────┐
│                           CORE                                  │
│  Portable, model-neutral contracts — single source of truth     │
│  core/pr-review/          Review, re-review, reporting          │
│  core/findings-handling/  Triage, fix, defer, reject            │
│  core/issue-authoring/    Draft and publish issues              │
│  core/issue-workflow/     start → implement → ship lifecycle    │
└─────────────────────────────────────────────────────────────────┘
```

## Layers in detail

### Core

Contains portable contracts only. Every contract defines inputs, steps, output
format, and the publication boundary. No core file contains repository-specific
commands, branch names, credentials, labels, or remote references.

| Area | Contracts | Skills |
| --- | --- | --- |
| `core/pr-review/` | `review-contract.md`, `profile-contract.md`, `reporting.md` | — (consumed directly) |
| `core/findings-handling/` | `findings-contract.md` | `handle-findings` |
| `core/issue-authoring/` | `issue-contract.md` | `author-issue` |
| `core/issue-workflow/` | `workflow-contract.md`, `start-issue-contract.md`, `implement-issue-contract.md`, `ship-change-contract.md`, `execute-issue-contract.md` | `start-issue`, `implement-issue`, `ship-change`, `execute-issue` |

### Adapters

Each adapter is a thin wrapper that contributes exactly two things:

1. **Reviewer identity** — the name used in summaries and publication fields
   (Claudio DR or Cody DR).
2. **Platform mechanics** — how to invoke the publisher, which CLI tools to use,
   and any platform-specific invocation differences documented in
   `docs/compatibility.md`.

Adapter SKILL.md files reference the corresponding core contract by path. They
must not embed finding tables, confidence thresholds, or summary templates.

```
plugins/claudio-dr/
  .claude-plugin/plugin.json    Plugin manifest for Claude Code
  agents/claudio-reviewer.md    Reviewer agent — binds to review-pr skill
  skills/
    review-pr/SKILL.md          → references core/pr-review/references/review-contract.md
    handle-pr-findings/SKILL.md → references core findings-handling contracts
    author-issue/               (planned)
    start-issue/SKILL.md        → references core/issue-workflow/skills/start-issue/SKILL.md
    implement-issue/SKILL.md    → references core/issue-workflow/skills/implement-issue/SKILL.md
    ship-change/SKILL.md        → references core/issue-workflow/skills/ship-change/SKILL.md
    execute-issue/SKILL.md      → references core/issue-workflow/skills/execute-issue/SKILL.md
```

`plugins/cody-dr/` mirrors this structure for Codex. Intentional platform
differences are documented in `docs/compatibility.md`.

### Profiles

A profile is a project-specific configuration file loaded at runtime. It
strengthens the core — adding architecture rules, required files, quality
commands, PR metadata, and publisher dispatch — but cannot weaken the evidence
threshold or the explicit-publication boundary.

```
profiles/craftcontrol.md
  ├── Project identity (repo, branch naming, quality command)
  ├── Required context (files to read before reviewing)
  ├── Architecture boundaries (layer ownership table)
  ├── Review checklist (project-specific additions to core)
  ├── Lifecycle skill mapping (entry points → portable skills)
  ├── PR metadata (base branch, labels, reviewers, merge policy)
  └── Publisher dispatch contract (modes, secret names only)
```

## Data flow

```
User invokes skill
      │
      ▼
Adapter SKILL.md
  sets identity ("Claudio DR")
  references core contract path
      │
      ▼
Core contract
  defines behavior (evidence, triage, publication boundary)
      │
      ▼
Profile (if loaded)
  adds project rules (architecture, quality command, publisher)
      │
      ▼
Output
  formatted finding / draft / summary
      │
      ▼  (only with explicit user authorization + profile publisher)
Publisher
  generates installation token → posts as reviewer bot → verifies authorship
```

## Publication model

Every external action follows the same three-step gate:

1. **Authorization** — the user must explicitly request publication for each
   action (review, reply, resolution, issue creation, push, PR creation).
2. **Publisher** — the target profile must document the publisher mode. Without
   it, the skill returns `not published`.
3. **Verification** — after every publisher action, the adapter verifies that
   the author, event, and target match the expected reviewer identity.

The personal `gh` session dispatches the publisher but is never used to
impersonate the reviewer or to post directly.

## Validation

`bin/check` enforces the layer boundaries at commit time:

- **Required paths**: every core contract, adapter skill, and profile must exist.
- **SKILL.md frontmatter**: all skills must have a valid `description` field.
- **Adapter drift**: adapter review-pr skills must reference the core contract
  and must not embed the finding class table or confidence threshold.
- **Parity**: both adapter reviewer agents must bind to `review-pr`; both sets
  of workflow adapter skills must reference their corresponding core skills.
- **Forbidden copies**: adapter-local copies of core contracts must not exist.
- **Secrets**: tracked files matching credential-like patterns fail the check.
