# Generic issue-to-change lifecycle

This example shows the portable `execute-issue` lifecycle for issue `#42` in
the neutral `acme/widgets` repository. It uses only illustrative values: a
real project profile supplies its branch convention, quality command, PR
metadata, and publisher details.

## 1. Start the explicit issue

The caller explicitly asks to execute `#42`. `start-issue` loads the one
project profile, reads the issue, and checks its declared dependencies before
creating a branch.

```md
## Start — #42

**Issue:** Document widget cache invalidation
**Branch:** `42-docs/widget-cache-invalidation` from `main`
**Profile:** `acme/widgets`
**Dependencies:** all resolved
**Next:** implement-issue
```

If dependency `#41` is still open, the lifecycle stops here instead of
guessing or creating a speculative change:

```md
## Handoff — start-issue

**Stopped at:** unresolved dependency #41
**Last verified head:** `a1b2c3d`
**Next step:** complete or explicitly waive dependency #41
```

## 2. Implement and validate one logical unit at a time

`implement-issue` addresses the acceptance criteria on the created branch.
After each logical change it runs the profile-owned command, for example
`make check`. A passing unit can be committed; the implementation phase never
pushes or opens a pull request.

```md
## Implementation — #42

**Branch:** `42-docs/widget-cache-invalidation`
**Commits:** 2
**Quality command:** passed
**Acceptance criteria:** all addressed
**Next:** ship-change
```

A failing quality gate is a terminal handoff for this execution. Later phases
do not run until the failure is fixed and validated:

```md
## Handoff — implement-issue

**Stopped at:** `make check` failed after commit 2: broken documentation link
**Last verified head:** `d4e5f6a`
**Next step:** fix the failing check, rerun `make check`, then resume
```

## 3. Ship the completed change

For an explicit `execute-issue` request, the normal delivery path is already
authorized: commit, push, and opening a fully populated PR. `ship-change`
runs the final quality gate, derives the title and body from the issue, and
uses the profile values rather than hardcoding them in the portable workflow.
When the profile supplies a PR template, the body retains every template
heading and fills each section with a change-specific answer or `Not
applicable`.

```md
## Ship — #42

**Branch:** `42-docs/widget-cache-invalidation`
**Final quality gate:** passed
**PR:** https://github.com/acme/widgets/pull/42
**Metadata applied:** `documentation`, milestone `v1`, assignee `maintainer`,
Project `Widgets` / `In Progress`
**Metadata verified:** base → `main`; labels → present; milestone → `v1`;
assignee → `maintainer`; Project → `In Progress`
```

If a caller invokes `ship-change` on its own without an explicit
issue-execution request, it prepares the same PR payload but does not publish
it:

```md
## Ship — #42

**Branch:** `42-docs/widget-cache-invalidation`
**Final quality gate:** passed
**PR:** not published
**Metadata applied:** none
**Metadata verified:** none

## Handoff — ship-change

**Stopped at:** standalone shipping has no push and PR-creation authorization
**Last verified head:** `d4e5f6a`
**Next step:** explicitly request issue execution or authorize shipping
```

Review publication, replies, and thread resolution are never implied by issue
execution. They require their own explicit authorization and a configured
project publisher.

## 4. Final orchestration summary

When all phases complete, `execute-issue` reports the outcome without hiding
the branch, validation, or PR state:

```md
## Execute — #42

**Phases completed:** start-issue · implement-issue · ship-change
**Stopped at:** none
**PR:** https://github.com/acme/widgets/pull/42
```
