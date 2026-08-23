# Compatibility model

## Portable contract

The core contracts cover all portable behavior. They live in `core/` and are
the single behavioral source of truth for all adapters:

| Core area | Location |
| --- | --- |
| PR review | `core/pr-review/references/` |
| Issue authoring | `core/issue-authoring/references/` |
| Findings handling | `core/findings-handling/references/` |
| Issue-to-change workflow | `core/issue-workflow/references/` + `core/issue-workflow/skills/` |

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
| Agent invocation | `@cody-reviewer review <ref>` |
| Local validation | `codex plugin validate ./plugins/cody-dr` |
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

A profile supplies target-repository context such as architecture, security
constraints, quality commands, metadata conventions, and reviewer identity. A
profile can strengthen the core contract but cannot weaken its evidence or
explicit-publication requirements.
