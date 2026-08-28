# Install Cody DR

Clone this private repository on the machine that runs Codex. Add its local
marketplace root, then install the plugin:

```bash
codex plugin marketplace add /absolute/path/to/dr-agents
codex plugin add cody-dr@dr-agents
```

Start a new Codex thread after installation. Use the `cody-reviewer` agent for
an isolated review pass on an explicit PR URL, branch, commit range, or local
diff:

```text
@cody-reviewer review https://github.com/acme/widgets/pull/42
```

You can also invoke the `review-pr` skill directly without the agent for a
lightweight pass. The reviewer is independent: it can review a PR from any
contributor and never executes the issue or modifies the reviewed branch. Add a project profile when the target repository has
architecture or quality rules beyond the portable core.

The plugin also exposes global agents: `cody-helper` for usage guidance,
`cody-reviewer` for an isolated review, `cody-author` to author a single issue,
`cody-executor` for an issue lifecycle, and `cody-findings` for findings
handling. `cody-designer` performs UX/UI design discovery and returns a Design
Brief without publishing or changing the project. Use `@cody-author draft issue` to create a standalone issue,
`@cody-designer assess this checkout flow` to prepare UX/UI direction,
`@cody-executor plan issue #42` for a read-only test-first plan,
`@cody-executor execute issue #42` for normal issue delivery,
`@cody-findings` to handle review findings, and `@cody-helper` to select the
right capability. From a target repository,
they discover exactly one local profile at `.agent-review/*/PROFILE.md`. With
no profile they use generic portable rules; they stop rather than guess when
more than one profile exists.

## Local validation and update

Codex has no standalone plugin-validation command. Run the catalog quality
check, then load the plugin directory in a local session:

```bash
bin/check
codex --plugin-dir ./plugins/cody-dr
```

After changing the plugin, bump the version in `.codex-plugin/plugin.json`,
reinstall from the same marketplace root, and start a new thread:

```bash
codex plugin add cody-dr@dr-agents
```

The installed plugin includes a read-only bundle of the portable core contracts,
so it works after marketplace installation without relying on a sibling catalog
checkout. The plugin never contains GitHub App keys or target-repository
credentials.

## Publisher dispatch

When a target profile documents a Cody DR GitHub App publisher, Codex may
dispatch it through the existing personal `gh` session without switching or
removing that session. Reinstall the plugin after updating the marketplace.

The same publisher integration can support replies to and resolution of existing
review threads; the target profile documents its inputs and verification steps.
For those thread actions, Cody DR uses its configured App first. If the requested
App operation is unavailable before dispatch, an explicitly authorized
authenticated personal account may publish the prepared action and is reported
as a personal fallback. A failed App dispatch or verification is reported as a
failure and never retried through that account.
For this repository, see `profiles/dr-agents.md` for the configuration
names and publication boundary; it contains no credential values.
