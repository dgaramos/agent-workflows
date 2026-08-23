# Ship-change contract

## Inputs

Require the working branch and the implementation summary from `implement-issue`.
Do not ship without confirmed passing quality gates.

## Steps

1. Run the profile's quality command one final time on the current head. Stop
   if it fails.
2. Prepare the PR:
   - Title: derived from the issue title.
   - Body: implementation summary and acceptance criteria checklist. When the
     profile declares a PR template, load it, retain every heading, and fill
     every section with the change-specific answer or an explicit `Not
     applicable`; do not replace it with a generic summary.
   - Metadata: labels, milestone, assignees, reviewers, and Projects from the profile.
3. Push the branch and create the fully populated PR. The issue-execution
   request already authorizes these normal delivery actions; do not ask again.
4. After creating the PR, run
   `core/issue-workflow/scripts/apply-pr-metadata.sh` with values from the
   profile. The helper applies and verifies the base branch, labels, milestone,
   assignees, reviewers, and Project item state. Its arguments, including any
   Project owner, number, and status, are profile-owned.
5. If a required field cannot be applied or verified, stop and emit a handoff
   with the PR URL, field, and failed command or permission. Do not claim a PR
   was shipped with complete metadata when the helper fails.

## Output

```md
## Ship — <issue reference>

**Branch:** `<branch-name>`
**Final quality gate:** <passed|failed: reason>
**PR:** <not requested|not published|<URL>>
**Metadata applied:** <labels, milestone, assignees, reviewers, Projects or none>
**Metadata verified:** <field → observed value, or failed field>
```

Do not publish review, comment, reply, or thread-resolution content as part of
shipping unless the user separately authorizes that publication.
