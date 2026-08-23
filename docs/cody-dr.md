# Install Cody DR

Clone this private repository on the machine that runs Codex. Add its local
marketplace root, then install the plugin:

```bash
codex plugin marketplace add /absolute/path/to/agent-workflows
codex plugin add cody-dr@agent-workflows
```

Start a new Codex thread after installation. Use the `cody-reviewer` agent for
an isolated review pass on an explicit PR URL, branch, commit range, or local
diff:

```text
@cody-reviewer review PR #42
```

You can also invoke the `review-pr` skill directly without the agent for a
lightweight pass. Add a project profile when the target repository has
architecture or quality rules beyond the portable core.

The plugin also exposes global agents: `cody-helper` for usage guidance,
`cody-reviewer` for an isolated review, `cody-workflow` for an issue lifecycle,
and `cody-findings` for findings handling. From a target repository, they discover exactly one local profile at
`.agent-review/*/PROFILE.md`. They stop rather than guess when there is no
profile for a lifecycle action or when more than one profile exists.

## Local validation and update

To validate the plugin without installing it, run:

```bash
codex plugin validate ./plugins/cody-dr
```

To load it locally for a session without publishing to the marketplace:

```bash
codex --plugin-dir ./plugins/cody-dr
```

After changing the plugin, bump the version in `.codex-plugin/plugin.json`,
reinstall from the same marketplace root, and start a new thread:

```bash
codex plugin add cody-dr@agent-workflows
```

The installed plugin includes a read-only bundle of the portable core contracts,
so it works after marketplace installation without relying on a sibling catalog
checkout. The plugin never contains GitHub App keys or target-repository
credentials.

## Publisher dispatch

Version 0.1.2 adds external-publisher dispatch: when a target profile documents
a Cody DR GitHub App publisher, Codex may dispatch it through the existing
personal `gh` session without switching or removing that session. Reinstall the
plugin after updating the marketplace.

The same publisher integration can support replies to and resolution of existing
review threads; the target profile documents its inputs and verification steps.
For this repository, see `profiles/agent-workflows.md` for the configuration
names and publication boundary; it contains no credential values.
