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

## Draft summary

Emit one summary block per authoring session:

```md
## Issue draft — <author name>

**Title:** <issue title>
**Profile:** <profile name or none>
**Profile-owned fields:** <applied: labels, milestone, … | unknown: profile not loaded>
**Publication:** <not requested|not published|published by <author name> as issue #N>
```
