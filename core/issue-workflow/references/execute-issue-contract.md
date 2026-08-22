# Execute-issue contract (orchestrator)

## Purpose

`execute-issue` composes `start-issue`, `implement-issue`, and `ship-change`
in sequence. It does not grant broader publication authorization than each
phase would allow standalone — push and PR creation still require explicit
user authorization when `ship-change` is reached.

## Steps

1. Run `start-issue`. Stop on any handoff.
2. Run `implement-issue`. Stop on any handoff.
3. Run `ship-change`. Stop if the quality gate fails or the user does not
   authorize push and PR creation.

Load the target profile once at step 1 and pass its context through all
phases. Do not reload or override the profile mid-execution.

## Authorization boundary

Confirm with the user before each external action (push, PR creation). A
"proceed end-to-end" instruction authorizes the orchestrator to run all phases
but does not pre-authorize external actions — each is confirmed at the point
where the phase reaches it.

## Output

Emit each phase's own output block in sequence, followed by a final summary:

```md
## Execute — <issue reference>

**Phases completed:** start-issue · implement-issue · ship-change
**Stopped at:** <phase name and reason, or none>
**PR:** <not requested|not published|<URL>>
```
