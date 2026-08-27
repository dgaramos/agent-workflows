# Ship-change contract

## Inputs

Require the working branch and the implementation summary from `implement-issue`.
Do not ship without confirmed passing quality gates.

## Steps

1. Apply PR-body and delivery-metadata guidance discovered from `CONTRIBUTING.md`
   following [contribution-guidance-contract](contribution-guidance-contract.md).
   A missing file is not a blocker. Surface any material conflict with the
   profile before opening the PR.
2. Run the profile's quality command one final time on the current head. Stop
   if it fails.
3. Prepare the PR:
   - Title: derived from the issue title.
   - Body: when `.github/pull_request_template.md` exists in the repository,
     read that file, fill every section with the change-specific answer or an
     explicit `Not applicable`, and pass the completed text to
     `gh pr create --body "$(cat .github/pull_request_template.md)"` (with
     the filled content, not the raw template). retain every heading; do not
     replace the template with a free-form summary. Opening a PR with a
     free-form body when a template exists is a contract violation. When no
     template file is present, use the implementation summary and acceptance
     criteria checklist as the body.
   - Metadata: labels, milestone, assignees, reviewers, and Projects from the profile.
4. Push the branch and create the fully populated PR. The issue-execution
   request already authorizes these normal delivery actions; do not ask again.
5. After creating the PR, dispatch the profile's `apply-pr-metadata` publisher
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
   an explicitly user-authorized authenticated personal account may run the
   helper as a fallback. Verify every field and report that account explicitly
   as the metadata publisher; never represent it as the reviewer App.
6. If a required field cannot be applied or verified, stop and emit a handoff
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
