# Install Claudio DR

Add this private repository as a Claude Code plugin marketplace, then install
the plugin:

```text
/plugin marketplace add dgaramos/agent-workflows
/plugin install claudio-dr@agent-workflows
```

Start a new Claude Code session after installation. Use the
`/claudio-dr:review-pr <PR URL or ref>` skill for an explicit review, or
`/claudio-dr:execute-issue #42` for normal issue delivery.

`review-pr` is independent of issue execution: it can review a PR authored by
any contributor and does not modify the reviewed branch.

The plugin also exposes global agents: `claudio-helper` for usage guidance,
`claudio-reviewer` for an isolated review, `claudio-author` to author a single
issue, `claudio-executor` for an issue lifecycle, `claudio-designer` for UX/UI
design discovery, and `claudio-findings` for findings handling. Use
`/claudio-dr:design-discovery assess this checkout flow` to prepare a Design
Brief, `/claudio-dr:plan-implementation #42` for a read-only test-first plan,
`/claudio-dr:execute-issue #42` for normal issue delivery, and
`/claudio-dr:handle-pr-findings` for review findings. From a target repository,
they discover exactly one local profile at `.agent-review/*/PROFILE.md`. With
no profile they use generic portable rules; they stop rather than guess when
more than one profile exists.

## Local validation and update

Validate the plugin and load it in a local session without publishing:

```bash
bin/check
claude plugin validate ./plugins/claudio-dr
claude --plugin-dir ./plugins/claudio-dr
```

After changing the plugin, bump the version in `.claude/plugin.json`, then
update the marketplace and reinstall:

```bash
/plugin marketplace update
/plugin update claudio-dr@agent-workflows
```

The installed plugin includes a read-only bundle of the portable core contracts,
so it works after marketplace installation without relying on a sibling catalog
checkout. The plugin never contains GitHub App keys or target-repository
credentials.

## Publisher dispatch

When a target profile documents a Claudio DR GitHub App publisher, Claude may
dispatch it through the existing personal `gh` session without switching or
removing that session. Update the plugin after updating the marketplace.

The same publisher integration can support replies to and resolution of existing
review threads; the target profile documents its inputs and verification steps.
For those thread actions, Claudio DR uses its configured App first. If the
requested App operation is unavailable before dispatch, an explicitly authorized
authenticated personal account may publish the prepared action and is reported
as a personal fallback. A failed App dispatch or verification is reported as a
failure and never retried through that account.
For this repository, see `profiles/agent-workflows.md` for the configuration
names and publication boundary; it contains no credential values.
