# CraftControl profile

Use this profile when reviewing or working in the CraftControl repository.
Load it before any review, findings-handling, issue-authoring, or lifecycle
skill runs in that target repository.

## Project identity

- **Repository:** `dgaramos/craftcontrol` (private)
- **Main branch:** `main`
- **Supported branches:** `main`, feature branches matching `<issue-number>-*`
- **Quality command:** `bin/check` (run from the repository root)

## Required context

Read before reviewing or implementing:

- `README.md` — project overview and entry-point map
- `AGENTS.md` — agent instructions and tool policy
- `CONTRIBUTING.md` — branch, commit, and PR conventions
- the target issue and its acceptance criteria
- changed files and their callers and tests

## Architecture boundaries

| Layer | Location | Rule |
| --- | --- | --- |
| Portable contracts | `core/` (agent-workflows) | Never modified by CraftControl work |
| Adapter mechanics | `plugins/` (agent-workflows) | Never modified by CraftControl work |
| Project rules | This profile | Strengthens core; never weakens evidence or publication boundary |

## Review checklist

In addition to the core review contract, verify:

- Commits follow Conventional Commits (`type(scope): description`).
- `bin/check` passes before any PR is considered shippable.
- No credentials, tokens, or secrets are introduced.
- Profile-owned fields are not hardcoded in portable contracts.

## Lifecycle skill mapping

| CraftControl entry point | Portable skill |
| --- | --- |
| Start an issue | `start-issue` with this profile |
| Implement changes | `implement-issue` with this profile |
| Open a PR | `ship-change` with this profile |
| Full lifecycle | `execute-issue` with this profile |
| Review a PR | `review-pr` with this profile |
| Handle findings | `handle-findings` with this profile |
| Author an issue | `author-issue` with this profile |

## PR metadata

Applied by `ship-change` when this profile is loaded:

- **Base branch:** `main`
- **Labels:** derived from issue type and scope; do not hardcode values here —
  apply them from the issue's label field.
- **Reviewers:** assigned from the issue's assignees or explicit user instruction.
- **PR template:** use the repository's `.github/pull_request_template.md` if
  present; otherwise use the implementation summary and acceptance-criteria
  checklist from `implement-issue`.
- **Merge policy:** squash merge; ensure the squash message includes the issue
  reference.

## Publication contract

Publication is always explicitly authorized. The publisher configuration is
discovered from repository variables and secrets by name only:

- Cody DR uses `CODY_DR_CLIENT_ID` and `CODY_DR_PRIVATE_KEY`
- Claudio DR uses `CLAUDIO_DR_CLIENT_ID` and `CLAUDIO_DR_PRIVATE_KEY`

Never read, print, copy, or commit their values.

The publisher must generate an installation token scoped to the CraftControl
repository, act as the matching GitHub App, then verify the author and event.

### Supported publisher modes

| Mode | Supported |
| --- | --- |
| PR review dispatch | Yes |
| Thread reply | Yes |
| Thread resolution | Yes |
| Issue creation (`create-issue`) | Yes |

For issue creation, the publisher receives: repository (`dgaramos/craftcontrol`),
title, body, and any profile-owned fields (labels, milestone, assignees) resolved
from the issue context. After creation, verify the issue author matches the
configured reviewer bot and record the issue number in the draft summary.

## Migration path

During rollout, the portable skills and this profile replace CraftControl's
original lifecycle skills. If a portable skill is unavailable or the profile
fails to load, the fallback is to surface a clear error and ask the user to
invoke the phase manually with explicit instructions. Never silently fall back
to a different behavior or skip a quality gate.

**Safe fallback:** if `bin/check` is unavailable in the target repository,
ask the user which validation command to run before proceeding; do not skip
validation.
