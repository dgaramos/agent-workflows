# Changelog

All notable changes to this catalog are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project uses
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.15] - 2026-08-29

### Added

- Portable spec-driven development contracts, profile-declared external spec
  resolution, and equivalent Cody DR and Claudio DR entrypoints.

### Changed

- `execute-issue` now formally completes
  `start-issue → plan-implementation → implement-issue → ship-issue`; the
  shipping phase runs final validation, applies verified profile metadata, and
  emits its own output block before execution completes.
- Standalone `ship-issue` retains its explicit approval requirement, while an
  approved `execute-issue` lifecycle needs no second shipping confirmation.
- Updated Cody DR and Claudio DR to version `0.1.25`; reinstall or update the
  selected plugin after refreshing its marketplace source.

## [0.1.9] - 2026-08-24

### Changed

- Findings replies and thread resolutions now prefer and verify the configured
  reviewer App, with an explicitly authorized authenticated personal-account
  fallback only when the requested App operation is unavailable before
  dispatch. Failed App publication or verification never falls back silently.
- Updated Cody DR and Claudio DR to version `0.1.9`; reinstall or update the
  selected plugin after refreshing its marketplace source.

## [0.2.0] - 2026-08-22

### Added

- Canonical portable review contracts and equivalent Cody DR and Claudio DR
  adapters.
- Portable findings handling, issue authoring, and issue-to-change lifecycle
  skills.
- Consumer profile support and documented publisher dispatch boundaries.

### Changed

- Consolidated adapter behavior around the portable core contracts.

## [0.1.0] - 2026-08-20

### Added

- Initial catalog layout for core contracts, adapters, profiles, and examples.
- Cody DR and Claudio DR review plugins and the initial PR quality gate.
