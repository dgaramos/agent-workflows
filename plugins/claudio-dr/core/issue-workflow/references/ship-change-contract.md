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
4. After creating the PR, dispatch the profile's `apply-pr-metadata` publisher
   workflow via `gh workflow run`. When the profile is loaded and declares any
   metadata fields (labels, milestone, assignee, project, status), this step
   is mandatory; skip it only when the profile declares no metadata fields at
   all. The dispatch command takes the form:

   ```sh
   gh workflow run <workflow-file> \
     --field pr_number=<PR number> \
     --field base_branch=<base branch> \
     --field labels_json='<JSON array>' \
     --field assignees_json='<JSON array>' \
     --field milestone_number=<number> \
     --field project_owner=<owner> \
     --field project_number=<number> \
     --field project_status=<status>
   ```

   Pass every profile-declared metadata field as a workflow input; omit only
   fields the profile does not declare. Wait for the run to complete and verify
   its configured App identity plus the base branch, labels, milestone,
   assignees, and Project item state. The workflow uses an installation token
   internally and may invoke `core/issue-workflow/scripts/apply-pr-metadata.sh`
   as an implementation detail. If that publisher is unavailable or fails,
   report metadata as not published and stop with a handoff; do not substitute
   personal-account publication.
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
**Metadata publisher:** <verified App actor|personal fallback: @login|not published: reason>
```

Do not publish review, comment, reply, or thread-resolution content as part of
shipping unless the user separately authorizes that publication.
