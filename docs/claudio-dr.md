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

Version 0.1.1 adds external-publisher dispatch: when a target profile documents
a Claudio DR GitHub App publisher, Claude may dispatch it through the existing
personal `gh` session without switching or removing that session. Update the
plugin after updating the marketplace.

The same publisher integration can support replies to existing review threads;
the target profile documents its reply inputs and verification step.

After changing an installed plugin, update its version, run `/plugin marketplace
update`, then `/plugin update claudio-dr@agent-workflows`. The plugin never
contains GitHub App keys or target-repository credentials.
