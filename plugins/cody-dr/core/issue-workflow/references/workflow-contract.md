# Portable issue-to-change workflow contract

## Profile-owned fields

The following fields belong to the target profile and must never be hardcoded
in core workflow behavior:

- branch naming convention and base branch;
- required PR metadata: labels, milestone, reviewers, Projects, PR template;
- remote names and push targets;
- merge policy (squash, merge commit, rebase);
- quality command and known check limitations.

When no profile is loaded, state that limitation at the start of each phase
and ask the user to supply the missing values before proceeding.

## Quality gate

Run the profile's quality command after every logical implementation unit and
again before shipping. If the quality command fails at any point:

- stop the current phase;
- do not claim the work is done;
- do not proceed to the next phase;
- report the failure with the command output.

## Publication boundary

Push, PR creation, and merge are external actions. Require explicit user
authorization before each external action. Do not infer authorization from a
prior phase or from a general "proceed" instruction that does not name the
specific action.

The orchestrator (`execute-issue`) composes phases sequentially but does not
grant broader publication authorization than each standalone phase would allow.

## Handoff at stop

When a phase stops without completing (quality gate failure, missing
authorization, or missing profile values), emit a handoff block:

```md
## Handoff — <phase name>

**Stopped at:** <reason>
**Last verified head:** `<sha or none>`
**Next step:** <what the user must do to continue>
```
