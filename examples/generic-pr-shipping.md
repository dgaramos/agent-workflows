# Generic PR metadata shipping

A target profile supplies the values and `apply-pr-metadata` publisher that are
intentionally absent from the portable core. An explicit issue-execution request
authorizes `gh pr create`; ship-issue dispatches that publisher and waits for
its verified App result. Inside the publisher, the installation-token workflow
may run:

```bash
core/issue-workflow/scripts/apply-pr-metadata.sh \
  --repo acme/widgets --pr 42 --base main \
  --label enhancement --milestone v1 \
  --assignee maintainer \
  --project-owner acme --project-number 7 --project-status "In Progress"
```

The helper applies each field, then reads the PR and Project back. It fails on
any missing or mismatched required value; callers report that failure rather
than handing off a partially configured PR. An adapter never runs it through a
personal `gh` session; an unavailable publisher leaves metadata not published.

For a user-owned Project, a profile may explicitly authorize an authenticated
personal fallback after the App publisher cannot complete that Project step.
The outcome identifies the personal actor; it never labels that action as App
publication. Do not request organization-Projects permission for a user-owned
Project.

## Lifecycle handoff reporting

When a lifecycle phase inspects a repository `CONTRIBUTING.md`, its handoff
makes the result visible to the next phase. For example:

```md
**Contribution guidance:** applied: branch naming, Conventional Commits, bin/check
```

The same field appears in the Start, Implementation, and Ship output templates.
If no file exists it reports `not found`; a material conflict reports `conflict:`
with the reason and stops for direction.
