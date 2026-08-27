# Execute-issue contract (orchestrator)

## Purpose

`execute-issue` is the implementation-only phase, run after approved planning
and branch preparation.

## Steps

1. Require approved `plan-issue` and `start-issue` handoffs.
2. Implement and commit the approved plan with validation after each unit.
3. Stop and wait for explicit approval before `ship-issue`; do not push or open a PR.

Load the target profile once at step 1 and pass its context through all
phases. Do not reload or override the profile mid-execution.

## Authorization boundary

The explicit issue-execution request authorizes branch creation,
implementation, validation, commits, push, and a fully populated PR. It does
not authorize review, comment, reply, or thread-resolution publication.

## Output

Emit each phase's own output block in sequence, followed by a final summary:

```md
## Execute — <issue reference>

**Phases completed:** execute-issue
**Next:** ship-issue (awaiting explicit approval)
```
