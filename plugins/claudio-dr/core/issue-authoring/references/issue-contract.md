# Portable issue authoring contract

## Draft-first behavior

Always produce a complete draft before asking anything. Ask only for decisions
that are materially missing and cannot be inferred from the problem statement or
the loaded profile. Do not ask for labels, assignees, milestones, or Projects —
those are profile-owned. Do not publish until the user explicitly authorizes it.

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
