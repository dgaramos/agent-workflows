# CraftControl profile

The private CraftControl profile keeps target-specific safeguards outside the
portable core and the Cody DR / Claudio DR plugins. It is intentionally not a
public marketplace dependency.

## Use it

Keep a local checkout of `dgaramos/agent-workflows` available to the reviewer,
then provide the profile explicitly with the PR reference. For example:

```text
review-pr https://github.com/dgaramos/craftcontrol/pull/123
Use profiles/craftcontrol/PROFILE.md from the agent-workflows checkout.
```

```text
/claudio-dr:review-pr https://github.com/dgaramos/craftcontrol/pull/123
Use profiles/craftcontrol/PROFILE.md from the agent-workflows checkout.
```

The profile selects the applicable layer checklists, quality commands,
contribution metadata, identities, and publication boundary. It never triggers
review automatically.

## Migration and rollback

Adoption is additive. Keep CraftControl's repository-native `review-pr` skills
in place while validating the profile against real PRs. If the catalog checkout
or either adapter is unavailable, invoke the existing CraftControl entry point
instead; it preserves the same manual invocation and incremental re-review
behavior. Removing this profile does not modify CraftControl, installed
plugins, GitHub Apps, or PR history.
