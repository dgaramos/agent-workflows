# Install Cody DR

Clone this private repository on the machine that runs Codex. Add its local
marketplace root, then install the plugin:

```bash
codex plugin marketplace add /absolute/path/to/agent-workflows
codex plugin add cody-dr@agent-workflows
```

Start a new Codex thread after installation. Use `review-pr` with an explicit
PR URL, branch, commit range, or local diff. Add a project profile when the
target repository has architecture or quality rules beyond the portable core.

For local changes to the plugin, update its Codex cachebuster, reinstall from
the same marketplace, and start a new thread. The plugin never contains GitHub
App keys or repository credentials.
