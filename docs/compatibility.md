# Compatibility model

## Portable contract

The core contracts cover all portable behavior. They live in `core/` and are
the single behavioral source of truth for all adapters:

| Core area | Location |
| --- | --- |
| PR review | `core/pr-review/references/` |
| Issue authoring | `core/issue-authoring/references/` |
| Findings handling | `core/findings-handling/references/` |
| Issue-to-change workflow and test-first planning | `core/issue-workflow/references/` + `core/issue-workflow/skills/` |

## Adapters

Both adapters implement the same portable contracts. Their intentional
differences are packaging and invocation only — they must not change the meaning
of any portable contract without documenting a version break here.

## Canonical reviewer identities

The display name, GitHub App, and verified GitHub actor below are different
representations of one reviewer identity. Publisher availability is per
operation and is declared by the target profile; an unavailable operation does
not mean an App is inactive.

| Reviewer | Display name | GitHub App | Verified GitHub actor |
| --- | --- | --- | --- |
| Cody DR | Cody DR | Cody DR GitHub App | `cody-dr[bot]` |
| Claudio DR | Claudio DR | Claudio DR GitHub App | `claudio-dr[bot]` |

### Claudio DR (Claude Code)

| Aspect | Value |
| --- | --- |
| Platform | Claude Code |
| Plugin manifest | `.claude-plugin/plugin.json` |
| Reviewer agent | `plugins/claudio-dr/agents/claudio-reviewer.md` |
| Invocation | `/claudio-dr:review-pr <PR URL or ref>` |
| Issue authoring | `/claudio-dr:author-issue <problem statement>` |
| Implementation planning | `/claudio-dr:plan-implementation <issue>` |
| Agent invocation | `@claudio-reviewer review <ref>` |
| Local validation | `claude plugin validate ./plugins/claudio-dr` |
| Local session | `claude --plugin-dir ./plugins/claudio-dr` |
| Update flow | bump version → `/plugin marketplace update` → `/plugin update claudio-dr@agent-workflows` |

### Cody DR (Codex)

| Aspect | Value |
| --- | --- |
| Platform | Codex |
| Plugin manifest | `.codex-plugin/plugin.json` |
| Reviewer agent | `plugins/cody-dr/agents/cody-reviewer.md` |
| Invocation | `review-pr <PR URL or ref>` |
| Issue authoring | `author-issue <problem statement>` |
| Implementation planning | `plan-implementation <issue>` |
| Agent invocation | `@cody-reviewer review <ref>` |
| Local validation | `bin/check` + `codex --plugin-dir ./plugins/cody-dr` |
| Local session | `codex --plugin-dir ./plugins/cody-dr` |
| Update flow | bump version → reinstall from marketplace root → new thread |

### Documented differences that do not weaken the core

- **SKILL.md `name` field**: Claudio DR `review-pr/SKILL.md` omits the `name:`
  frontmatter key because Claude Code discovers skills by directory name. Cody
  DR includes `name: review-pr` for explicit Codex registration. Both load the
  same core contract.
- **Agent format**: both use the same markdown frontmatter schema (`name`,
  `description`, `skills`). The agent body differs only in reviewer identity.
- **Update mechanics**: Claude Code uses `/plugin update`; Codex requires a
  reinstall and a new thread. Neither difference affects review behavior.

## Profiles

A profile is the target repository's specialization layer. It supplies local
facts such as architecture, security constraints, quality commands, metadata
conventions, and publisher capability; it can strengthen the core contract but
cannot weaken its evidence or explicit-publication requirements.

Place one profile in the target repository at:

```text
.agent-review/<project-name>/PROFILE.md
```

Global Cody DR and Claudio DR agents discover the sole matching profile from
the current repository. With no profile, an explicitly authorized generic
review may continue without project rules; lifecycle and publication actions
stop. With multiple profiles, the agents stop and ask which one applies rather
than selecting by directory order.

### Put project behavior in `PROFILE.md`

Keep every project-specific divergence from the portable contract in the
profile, including:

- the quality-gate command and known check limitations;
- branch naming, base branch, and merge policy;
- labels, milestone, assignees, reviewers, Project state, and PR template;
- required context files, architecture boundaries, and layer checklists;
- extra push remotes or deployment restrictions;
- the publisher dispatch contract, inputs, verified actor, and available or
  unavailable publisher modes.

This keeps `core/` portable and lets the same installed plugin operate in more
than one repository without copying target architecture or credentials.

### Keep local wrappers thin

Local agents are optional compatibility entrypoints. A wrapper should contain
only the reviewer identity, a binding to the installed adapter skill, and (when
needed for an older repository layout) an explicit profile reference. It must
not repeat review rules, lifecycle steps, checklists, publisher commands, or
quality gates.

As a rule of thumb, a local agent longer than roughly ten lines is probably
carrying behavior that belongs in `PROFILE.md`. Prefer the global plugin agents
(`cody-reviewer`, `cody-workflow`, `cody-findings`, and their Claudio
counterparts) for new projects; they discover the profile automatically.

### Example split

| Concern | Correct owner |
| --- | --- |
| Evidence threshold, finding format, explicit-publication boundary | `core/` |
| Cody/Claudio identity and platform invocation | `plugins/` |
| `bin/check`, architecture guidance, PR metadata, deployment policy | target `PROFILE.md` |
| A legacy alias that delegates to an installed skill | thin local wrapper |
