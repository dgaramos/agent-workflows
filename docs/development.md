# Development

## Local checks

Run:

```bash
bin/check
```

The quality check validates catalog boundaries, skill frontmatter, public
capability parity, manifests, generic examples, tracked sensitive-looking
files, and whitespace. GitHub Actions runs the same command for pull requests
and pushes to `main`.

## Testing installed adapters

Validate the Claude distributable plugin before testing it locally:

```bash
claude plugin validate ./plugins/claudio-dr
```

Codex has no standalone plugin-validation command. Run `bin/check` from the
catalog, then load the Cody DR directory in a local session to validate its
installable behavior.

For a local development session, load the plugin directory directly:

```bash
codex --plugin-dir ./plugins/cody-dr
claude --plugin-dir ./plugins/claudio-dr
```

After a Cody DR change, bump its manifest version, reinstall it from the
marketplace root, and start a new Codex thread. After a Claudio DR change,
bump its version, run `/plugin marketplace update`, then
`/plugin update claudio-dr@agent-workflows`.

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
