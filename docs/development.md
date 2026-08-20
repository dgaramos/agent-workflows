# Development

## Local checks

Run:

```bash
bin/check
```

The quality check validates required catalog boundaries, skill frontmatter,
tracked sensitive-looking files, and whitespace. GitHub Actions runs the same
command for pull requests and pushes to `main`. Claude plugin manifests are
also validated with `claude plugin validate <path>` when their adapter changes.

## Testing a future adapter

- Codex plugins are tested from a local marketplace during development.
- Claude Code plugins are tested with `claude --plugin-dir <path>` and validated
  with `claude plugin validate <path>`.

Do not treat a locally installed plugin as proof that an installation workflow
works; document and validate the fresh-install path as part of each adapter.
