# Install Claudio DR

Add this private repository as a Claude Code plugin marketplace, then install
the plugin:

```text
/plugin marketplace add dgaramos/agent-workflows
/plugin install claudio-dr@agent-workflows
```

Use `/claudio-dr:review-pr <PR URL or ref>` for an explicit review. For local
development, validate and load the plugin without publishing it:

```bash
claude plugin validate ./plugins/claudio-dr
claude --plugin-dir ./plugins/claudio-dr
```

The plugin also exposes global agents: `claudio-helper` for usage guidance,
`claudio-reviewer` for an isolated review, `claudio-workflow` for an issue
lifecycle, and `claudio-findings` for findings handling. Use
`/claudio-dr:execute-issue #42` for normal issue delivery and
`/claudio-dr:handle-pr-findings` for review findings. From a target repository,
they discover exactly one local profile at `.agent-review/*/PROFILE.md`. With
no profile they use generic portable rules; they stop rather than guess when
more than one profile exists.

When a target profile documents a Claudio DR GitHub App publisher, Claude may
dispatch it through the existing personal `gh` session without switching or
removing that session. Update the plugin after updating the marketplace.

The same publisher integration can support replies to and resolution of existing
review threads; the target profile documents its inputs and verification steps.
For this repository, see `profiles/agent-workflows.md` for the configuration
names and publication boundary; it contains no credential values.
After changing an installed plugin, update its version, run `/plugin marketplace
update`, then `/plugin update claudio-dr@agent-workflows`. The installed plugin
includes a read-only bundle of the portable core contracts, so it does not rely
on a sibling catalog checkout. The plugin never contains GitHub App keys or
target-repository credentials.
