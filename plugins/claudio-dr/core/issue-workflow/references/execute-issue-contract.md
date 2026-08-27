# Execute-issue contract (orchestrator)

## Purpose

`execute-issue` composes `start-issue`, `plan-implementation`,
`implement-issue`, and `ship-change` in sequence. An explicit request to
execute an issue authorizes the full normal delivery, including push and PR
creation.

## Steps

1. Run `start-issue`. Stop on any handoff.
2. Run `plan-implementation` and emit its complete read-only plan. After the
   plan is printed, halt and wait for explicit user confirmation before
   proceeding. No file may be touched before confirmation is received. If the
   user redirects or adjusts, re-emit a revised plan and wait again.
3. Run `implement-issue` from the confirmed plan. Stop on any handoff.
4. Run `ship-change`. Stop only for a failed quality gate, missing permission,
   unresolved dependency, or material out-of-scope decision.

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

**Phases completed:** start-issue · plan-implementation · implement-issue · ship-change
**Stopped at:** <phase name and reason, or none>
**PR:** <not requested|not published|<URL>>
```
