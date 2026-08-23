# Generic PR metadata shipping

A target profile supplies the values that are intentionally absent from the
portable helper. After an authorized `gh pr create`, ship-change runs:

```bash
core/issue-workflow/scripts/apply-pr-metadata.sh \
  --repo acme/widgets --pr 42 --base main \
  --label enhancement --milestone v1 \
  --assignee maintainer \
  --project-owner acme --project-number 7 --project-status "In Progress"
```

The helper applies each field, then reads the PR and Project back. It fails on
any missing or mismatched required value; callers report that failure rather
than handing off a partially configured PR.
