# Generic project-profile discovery

From a repository working directory, a Claudio DR or Cody DR workflow searches
only `.agent-review/*/PROFILE.md` below the repository root.

- With exactly one match, it loads that profile for quality commands, branch
  policy, publication settings, and project checklists.
- With no match, an explicitly authorized generic review may proceed without
  project rules; an issue workflow stops and asks for a profile.
- With two matches, it stops and asks which profile applies. It never guesses.

For example, `example-api/.agent-review/example-api/PROFILE.md` is discovered
when the workflow runs from `example-api/`. The profile stays in the target
repository; neither the plugin nor the portable core copies it.
