# Development

## Local checks

Run:

```bash
bin/check
```

The quality check validates required catalog boundaries, skill frontmatter,
tracked sensitive-looking files, and whitespace. GitHub Actions runs the same
command for pull requests and pushes to `main`. Later plugin issues will extend
it with Codex and Claude validation commands.

## Testing a future adapter

- Codex plugins are tested from a local marketplace during development.
- Claude Code plugins are tested with `claude --plugin-dir <path>` and validated
  with `claude plugin validate <path>`.

Do not treat a locally installed plugin as proof that an installation workflow
works; document and validate the fresh-install path as part of each adapter.

## Releases

Release only a merged `main` commit. First update `CHANGELOG.md`, bump every
affected plugin manifest version, run `bin/check`, and merge the release PR.
Then create and push an annotated semantic-version tag and publish the matching
GitHub release from that tag:

```bash
git tag -a vX.Y.Z -m "vX.Y.Z" <merged-main-sha>
git push origin vX.Y.Z
gh release create vX.Y.Z --repo dgaramos/agent-workflows --title "vX.Y.Z" --notes-file CHANGELOG.md
```

Use the release notes for that version's section only. Record incompatible
portable-contract changes under `Changed` and explain their compatibility
impact in `docs/compatibility.md`.
