# Portable issue authoring contract

## Mode detection

Before drafting, classify the input into one of four modes. The agent may
override classification with an explicit prefix (e.g. `bug: …`, `feature: …`);
otherwise auto-detect from the input content:

| Mode | Detection signal |
|---|---|
| `bug` | stacktrace, error message, "broken", "doesn't work", wrong behavior |
| `feature` | new capability, user need, "it would be nice if", "add support for" |
| `chore` | tech debt, refactor, dependency update, cleanup, "remove", "migrate" |
| `spike` | open-ended uncertainty, research question, "how should we", "explore" |

### Bug mode

Before drafting, investigate the codebase:

1. Read every file referenced in the stacktrace or error message.
2. Grep for the error site and any relevant call sites.
3. Check `git log` for recent changes in the affected area.
4. Document: likely cause, reproduction steps, and impact.

Include these findings in the draft as an annotated stack and a root cause
hypothesis. Do not ask questions — investigate first.

### Feature mode

Run a short discovery pass before drafting:

- When the input is vague (no clear problem, no affected users, no alternatives
  mentioned): ask at most 3 focused questions covering problem, affected users,
  and alternatives considered. Wait for answers before drafting.
- When the input is already detailed (problem is clear, scope is defined): skip
  questions and draft immediately.

When the input includes a Design Brief from `design-discovery`, use its handoff
as the discovery result. Incorporate the evidence, UX direction, constraints,
accessibility considerations, success criteria, assumptions, and open questions
into the existing issue structure where relevant. Do not add a new mandatory
issue section, publish the design artifact, or treat the brief as authorization
to create the issue.

When the profile declares an authorized exact spec source and its trio is
available there, read `requirements.md` for acceptance criteria and `design.md`
for constraints. Treat it as context only, include `Spec: <location>` in the
body without a new mandatory section, and preserve existing behavior otherwise.
With no complete, exact, accessible declaration, do not infer or access an
external repository or path.

### Chore and spike modes

Before drafting, assess scope and risk:

- For `chore`: identify affected files, estimate change surface, and flag any
  breaking-change risk.
- For `spike`: define the question to answer and the done criterion explicitly
  in the draft.

No questions are required; draft after the assessment.

## Draft-first behavior

Always produce a complete draft before asking anything except for the feature
mode vague-input case above. Ask only for decisions that are materially missing
and cannot be inferred from the problem statement or the loaded profile. Do not
ask for labels, assignees, milestones, or Projects — those are profile-owned.
Do not publish until the user explicitly authorizes it.

## Issue structure

Every issue draft must include:

- **Context**: the concrete problem or gap being addressed; one or two sentences.
- **What to do**: the minimal set of actions needed to close the issue; use a
  short bulleted list.
- **Expected result**: what the system looks like after the issue is resolved.
- **Acceptance criteria**: a checklist of verifiable conditions; each item is
  falsifiable on its own. Phrase as: "Given …, when …, then …".
- **Dependencies** *(omit if none)*: explicit `blocked-by` or `blocking` links.
- **Limitations** *(omit if none)*: known constraints or out-of-scope items.

Omit sections that add no information for this specific issue. Do not add
sections that are not in this list.

## Profile-owned fields

The following fields belong to the target profile and must not be hardcoded in
the draft:

- labels
- assignees
- milestone
- Projects
- issue templates

When a profile supplies these values, apply them exactly. When no profile is
loaded, produce the draft body only; state that profile-owned fields are
unknown.

## Publication boundary

Publish only when the user explicitly authorizes it and the target profile
documents a `create-issue` publisher mode.

Without a publisher or authorization, return the complete formatted draft as
`not published`.

After publishing, verify that the created issue's author matches the configured
reviewer bot identity. If verification fails, report the failure and do not mark
the issue as published.

## Direct authorship prohibition

`gh issue create` and any direct GitHub API call authenticated as the
human user are **forbidden** for issue creation under all circumstances.

- If the profile declares a `create-issue` publisher: dispatch that workflow.
  Direct API calls or `gh issue create` as the authenticated user are not an
  acceptable substitute, even when the workflow is unavailable or fails.
- If the profile has no `create-issue` publisher: return the draft as
  `not published`. Do not fall back to user-authenticated authorship.

The personal-account fallback documented in reviewer contracts applies only to
review operations when no bot publisher is configured. It does not extend to
issue creation under any circumstance.

## Publication mechanics

When publication is authorized, follow these steps exactly:

1. Dispatch the profile's `create-issue` workflow, passing: `title`, `body`,
   `labels`, `assignees`, and `milestone`. Do not omit fields that the profile
   declares — pass them as workflow inputs.
2. Never use a direct GitHub API call authenticated as a human user. The
   `create-issue` mode is the only permitted publication path.
3. The issue body must conform to the profile-declared template structure. Match
   every section heading in the repository's `.github/ISSUE_TEMPLATE/` template;
   do not add or remove sections.
4. After the workflow completes, retrieve the created issue and inspect its
   `author.login`. If it does not match the configured reviewer bot identity
   (e.g. `claudio-dr[bot]`), mark the issue as `not published` and report the
   mismatch. Do not fall back to user authorship — a bot-identity failure is a
   hard stop, not a degraded-mode trigger.
## Draft summary

Emit one summary block per authoring session:

```md
## Issue draft — <author name>

**Title:** <issue title>
**Profile:** <profile name or none>
**Profile-owned fields:** <applied: labels, milestone, … | unknown: profile not loaded>
**Publication:** <not requested|not published|published by <author name> as issue #N>
```
