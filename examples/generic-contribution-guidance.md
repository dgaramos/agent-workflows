# Generic contribution-guidance discovery

This example shows how the portable contribution-guidance discovery step
behaves during the `execute-issue` lifecycle in two scenarios: a repository
that provides `CONTRIBUTING.md` and one that does not. All values are
illustrative; a real project profile supplies its branch convention, quality
command, PR metadata, and publisher details.

## Scenario A — repository with `CONTRIBUTING.md`

The `acme/widgets` repository contains a `CONTRIBUTING.md` that specifies:

- Branch naming: `<issue-number>-<type>/<slug>`
- Commit format: Conventional Commits with `Signed-off-by` trailer
- Validation: run `make lint` and `make test` before opening a PR
- PR body: use the project PR template at `.github/pull_request_template.md`

### start-issue behavior

After loading the profile and resolving the issue, `start-issue` inspects
`CONTRIBUTING.md` before creating the branch:

```md
## Start — #42

**Issue:** Add widget cache invalidation
**Branch:** `42-feat/widget-cache-invalidation` from `main`
**Profile:** `acme/widgets`
**Contribution guidance:** applied: branch naming `<issue>-<type>/<slug>`,
  Signed-off-by trailer, validation commands `make lint && make test`
**Dependencies:** all resolved
**Next:** implement-issue
```

The branch name follows the `CONTRIBUTING.md` pattern. The profile's base
branch (`main`) is authoritative and is not overridden.

### implement-issue behavior

`implement-issue` applies the commit format and validation commands discovered
from `CONTRIBUTING.md`. Each commit carries the `Signed-off-by` trailer in
addition to the adapter's `Co-Authored-By` trailer. The validation sequence
runs `make lint` and `make test` after each logical unit.

### ship-issue behavior

`ship-issue` reads `.github/pull_request_template.md`, fills every section,
and passes the completed body to `gh pr create`. The `make lint && make test`
validation from `CONTRIBUTING.md` runs before opening the PR.

```md
## Ship — #42

**Branch:** `42-feat/widget-cache-invalidation`
**Final quality gate:** passed
**Contribution guidance:** applied: PR template, make lint && make test
**PR:** https://github.com/acme/widgets/pull/99
**Metadata applied:** `enhancement`, milestone `v2`, assignee `maintainer`,
Project `Widgets` / `In Progress`
**Metadata verified:** base → `main`; labels → present; milestone → `v2`;
assignee → `maintainer`; Project → `In Progress`
```

## Scenario B — repository without `CONTRIBUTING.md`

The `beta/gadgets` repository does not have a `CONTRIBUTING.md`. The lifecycle
continues under profile and portable rules without failure.

### start-issue behavior

```md
## Start — #7

**Issue:** Fix gadget timeout
**Branch:** `7-fix/gadget-timeout` from `main`
**Profile:** `beta/gadgets`
**Contribution guidance:** not found
**Dependencies:** all resolved
**Next:** implement-issue
```

The branch name uses the profile's convention. No contribution guidance is
applied, and no error is raised.

## Scenario C — material conflict between profile and `CONTRIBUTING.md`

The `delta/tools` repository profile specifies base branch `release` and
labels `["bug"]`, but `CONTRIBUTING.md` says all branches must target `main`
and carry no labels. Because the target branch is a material delivery rule,
the lifecycle surfaces the conflict rather than silently choosing:

```md
## Handoff — start-issue

**Stopped at:** material conflict between profile and CONTRIBUTING.md
  Profile base branch: `release`
  CONTRIBUTING.md base branch: `main`
**Last verified head:** none (branch not yet created)
**Next step:** confirm which base branch to use for this issue, then resume
```

The lifecycle waits for explicit direction. It does not guess or apply either
rule silently.

## Scenario D — unreadable `CONTRIBUTING.md`

If `CONTRIBUTING.md` exists but cannot be parsed (for example it is a binary
file or is encoded unexpectedly), the lifecycle records the problem, continues
under profile rules, and notes the skipped guidance:

```md
## Start — #15

**Issue:** Update rate-limit logic
**Branch:** `15-feat/rate-limit` from `main`
**Profile:** `gamma/api`
**Contribution guidance:** skipped: CONTRIBUTING.md could not be read
**Dependencies:** all resolved
**Next:** implement-issue
```
