# Implement-issue contract

## Inputs

Require the working branch created by `start-issue`, the resolved issue
context, and the `plan-implementation` output. Do not implement without a
confirmed branch, issue reference, and test-first plan.

## Steps

1. Follow the accepted plan criterion by criterion. For each executable
   behavior change, write or update the planned Red test first and verify its
   failure for the expected reason.
2. Make the smallest Green implementation that passes the planned happy path,
   failure path, relevant edge cases, and regression coverage. Refactor only
   with those tests still passing.
3. For an explicitly non-executable change, run the structural validation named
   in the plan. Do not claim TDD is inapplicable merely to avoid writing tests.
4. After each logical unit, run the profile's quality command. Stop immediately
   if it fails.
5. Commit each logical unit with a message that references the issue and
   describes the intent, not the mechanics.
6. Do not push, open a PR, or touch files outside the issue's stated scope.

## Output

```md
## Implementation — <issue reference>

**Branch:** `<branch-name>`
**Commits:** N
**Quality command:** <passed|failed at commit N: reason>
**Test-first evidence:** <Red/Green/Refactor evidence per criterion>
**Acceptance criteria:** <all addressed|not yet addressed: criterion>
**Next:** ship-change
```

Stop and emit a handoff block if the quality command fails or any acceptance
criterion cannot be addressed within the stated scope.
