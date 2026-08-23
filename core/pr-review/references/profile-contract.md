# Project profile contract

A profile may define:

- project identity and supported branches;
- required context files and architecture boundaries;
- layer-specific review checklists;
- quality commands and known check limitations;
- risk axes and public-contract rules;
- reviewer identity and optional publisher capability. Load
  `core/pr-review/references/reviewer-identity-contract.md` when a profile
  defines either.

A profile must not:

- weaken the core evidence threshold or explicit-publication boundary;
- contain credentials, secrets, private keys, or installation tokens;
- make automatic review mandatory without an explicit workflow outside the core.

## Publisher capability contract

A profile that provides a publisher must document:

- **reviewer identity**: display name, publisher integration, and the verified
  platform actor; the three values represent one reviewer, as defined by the
  reviewer identity contract;

- **dispatch**: how to invoke the publisher (command, API call, or webhook) and
  what inputs it requires (event type, repository, PR number, review body,
  inline comments);
- **reply mode**: how to send a reply into an existing review thread (required
  if the adapter supports thread replies);
- **resolution mode**: how to resolve a review thread (required if the adapter
  supports thread resolution);
- **create-issue mode**: how to create a GitHub issue (repository, title, body,
  and profile-owned fields such as labels, assignees, milestone, and Projects);
  required if the adapter supports issue authoring via the publisher.

A profile that does not document one of these modes signals that the operation
is unavailable and the adapter must return the prepared content as `not
published`. This does not imply that the reviewer App is inactive.

### Post-publication verification

After every publisher action, the adapter must verify:

- **After publishing a review**: the resulting review's author matches the
  expected reviewer identity and the event matches the authorized action
  (`REQUEST_CHANGES`, `COMMENT`, or `APPROVE`).
- **After replying to a thread**: the reply is authored by the expected reviewer
  in the intended thread, not as a separate review or personal comment.
- **After resolving a thread**: the expected reviewer resolved the intended
  thread; the thread state reflects resolution.
- **After creating an issue**: the created issue's author matches the configured
  reviewer bot identity and the issue number is recorded in the draft summary.

If verification fails, report the failure and do not mark the action as
published.
