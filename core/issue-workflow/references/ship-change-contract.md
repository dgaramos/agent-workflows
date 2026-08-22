# Ship-change contract

## Inputs

Require the working branch and the implementation summary from `implement-issue`.
Do not ship without confirmed passing quality gates.

## Steps

1. Run the profile's quality command one final time on the current head. Stop
   if it fails.
2. Prepare the PR:
   - Title: derived from the issue title.
   - Body: implementation summary, acceptance criteria checklist, and the
     profile's PR template (if provided).
   - Metadata: labels, milestone, reviewers, and Projects from the profile.
3. Push the branch and create the PR only when the user explicitly authorizes
   both actions. Do not push without authorization even if the PR body is ready.
4. After creating the PR, verify it targets the profile's base branch and that
   the required metadata was applied.

## Output

```md
## Ship — <issue reference>

**Branch:** `<branch-name>`
**Final quality gate:** <passed|failed: reason>
**PR:** <not requested|not published|<URL>>
**Metadata applied:** <labels, milestone, reviewers, Projects or none>
```

Without push and PR-creation authorization, return the prepared PR title, body,
and metadata as `not published` and stop.
