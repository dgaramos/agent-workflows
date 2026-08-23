# Execute-issue contract (orchestrator)

## Purpose

`execute-issue` composes `start-issue`, `implement-issue`, and `ship-change`
in sequence. An explicit request to execute an issue authorizes the full
normal delivery, including push and PR creation.

## Steps

1. Run `start-issue`. Stop on any handoff.
2. Run `implement-issue`. Stop on any handoff.
3. Run `ship-change`. Stop only for a failed quality gate, missing permission,
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

**Phases completed:** start-issue · implement-issue · ship-change
**Stopped at:** <phase name and reason, or none>
**PR:** <not requested|not published|<URL>>
```
