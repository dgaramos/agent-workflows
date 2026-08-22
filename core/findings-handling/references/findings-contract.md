# Portable findings-handling contract

## Verification before acting

Verify every finding against the current head before classifying or fixing it.
If the evidence location no longer exists or the described condition is gone,
classify the finding as `superseded` and do not act on it.

## Triage

Classify each finding as exactly one of:

| Classification | Condition |
| --- | --- |
| `fix now` | The finding is valid, the fix is within the PR's scope, and the change is minimal. |
| `defer` | The finding is valid but the fix is out of scope for this PR. |
| `reject` | The finding is invalid, already fixed, or the described condition does not exist on the current head. |

Do not fix more than the finding describes. Do not refactor, clean up, or
extend beyond the minimal correction. If a fix would require touching files or
logic outside the PR's scope, defer it instead.

## Fixing

For each `fix now` finding:

1. Make the minimal correction on the current head.
2. Run the profile's quality command. If it fails, stop; do not claim the
   finding is resolved until validation passes.
3. Keep the commit logically isolated — one finding per commit unless the
   profile explicitly allows batching.

If no profile is loaded, state that no quality command is available and ask
the user which validation to run before claiming resolution.

## Deferring out-of-scope findings

For each `defer` finding, produce a publication-ready issue draft using the
portable issue-authoring contract (`core/issue-authoring/references/issue-contract.md`).
The draft's context must reference the original finding and its evidence. Do
not create an unscoped code change as a substitute.

## Reply and resolution

Prepare reply text and thread-resolution text for every handled finding.
Do not publish a reply, resolve a thread, push, or merge unless the user
explicitly authorizes that external action.

For `fix now`: the reply states what was changed and that validation passed.
For `defer`: the reply states that the finding is valid but out of scope and
links the draft issue (or its published number if already created).
For `reject`: the reply states why the finding does not apply on the current head.

When authorized to publish, use the target profile's publisher per the reply
mode and resolution mode documented in
`core/pr-review/references/profile-contract.md`. Verify that each reply and
resolution is authored by the expected reviewer bot in the intended thread.
Never mark a finding resolved based only on a reply.

## Outcome summary

Emit one summary block per handling session:

```md
## Findings handled — <reviewer name>

**PR/ref:** <ref>
**Head verified:** `<sha>`
**Fix now:** N · **Defer:** N · **Reject:** N · **Superseded:** N
**Validation:** <passed|failed|not run: reason>
**Replies prepared:** N · **Published:** <N published|not requested|not published>
```
