# Example project profile

Copy this shape into the repository that owns the project. Replace every
placeholder with local facts; do not add target-specific details to `core/` or
the adapters in this catalog.

## Project identity

- **Repository:** `<owner>/<repository>`
- **Main branch:** `<default-branch>`
- **Supported branches:** `<branch-convention>`
- **Quality command:** `<project-quality-command>`

## Required context

Read before reviewing or implementing:

- `<project-overview-file>` — project overview and entry-point map
- `AGENTS.md` — agent instructions and tool policy, if present
- `<contribution-guide>` — branch, commit, and PR conventions
- the target issue and its acceptance criteria
- changed files, their callers, and relevant tests

## Project boundaries

Document the project's local ownership rules here. Keep portable behavior in
`core/`, model invocation and identity in `plugins/`, and architecture,
commands, metadata, and deployment assumptions in this target-owned profile.

## Review checklist

Add project-specific checks here. The checklist may strengthen the core review
contract, but it must not lower evidence thresholds or bypass the explicit
publication boundary.

## Lifecycle skill mapping

| Local entry point | Portable skill |
| --- | --- |
| Start an issue | `start-issue` with this profile |
| Implement changes | `implement-issue` with this profile |
| Open a PR | `ship-change` with this profile |
| Full lifecycle | `execute-issue` with this profile |
| Review a PR | `review-pr` with this profile |
| Handle findings | `handle-findings` with this profile |
| Author an issue | `author-issue` with this profile |

## PR metadata

- **Base branch:** `<default-branch>`
- **Labels:** `<label-policy>`
- **Reviewers:** `<reviewer-policy>`
- **PR template:** `<template-path-or-summary-format>`
- **Merge policy:** `<merge-policy>`

## Publication contract

Publication is always explicitly authorized. List only the target's supported
publisher modes and the names of configuration inputs; never store credential
values in the profile. After a publisher acts, verify its author, event, and
target match the configured reviewer identity.
