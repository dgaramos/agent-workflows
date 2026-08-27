# Start-issue contract

## Inputs

Require an approved `plan-issue` handoff. Do not create a branch before plan approval.

## Steps

1. Load the target profile. Resolve the issue: title, body, acceptance
   criteria, dependencies, and labels.
2. Confirm all blocking dependencies are resolved before proceeding. If any
   dependency is open, report it and stop.
3. Inspect `CONTRIBUTING.md` following
   [contribution-guidance-contract](contribution-guidance-contract.md). Record
   applicable branch-naming guidance or note its absence. A missing file is
   not a blocker. Surface any material conflict with the profile before
   proceeding.
4. Resolve the working branch name from the profile's branch naming convention,
   incorporating any non-conflicting `CONTRIBUTING.md` branch rules. Default
   to `<issue-number>-<slug>` when neither source specifies.
5. Create the working branch from the profile's base branch. Report the branch
   name and base.

## Output

```md
## Start — <issue reference>

**Issue:** <title>
**Branch:** `<branch-name>` from `<base>`
**Profile:** <profile name or none>
**Dependencies:** <all resolved|blocked by: #N, …>
**Contribution guidance:** <applied: <items> | not found | conflict: <description>>
**Next:** execute-issue (awaiting explicit approval)
```

Stop and emit a handoff block if any dependency is unresolved or the profile
is missing required branch values.
