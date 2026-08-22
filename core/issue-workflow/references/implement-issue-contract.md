# Implement-issue contract

## Inputs

Require the working branch created by `start-issue` and the resolved issue
context. Do not implement without a confirmed branch and issue reference.

## Steps

1. Read the issue's acceptance criteria. Plan the minimal set of changes that
   satisfies every criterion without broadening scope.
2. Make each logical change in isolation. After each unit, run the profile's
   quality command. Stop immediately if it fails.
3. Commit each logical unit with a message that references the issue and
   describes the intent, not the mechanics.
4. Do not push, open a PR, or touch files outside the issue's stated scope.

## Output

```md
## Implementation — <issue reference>

**Branch:** `<branch-name>`
**Commits:** N
**Quality command:** <passed|failed at commit N: reason>
**Acceptance criteria:** <all addressed|not yet addressed: criterion>
**Next:** ship-change
```

Stop and emit a handoff block if the quality command fails or any acceptance
criterion cannot be addressed within the stated scope.
