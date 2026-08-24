---
description: Claudio DR drafts a structured GitHub issue and publishes it only with explicit authorization through a configured project publisher.
---

# Claudio DR author-issue

Reviewer identity: **Claudio DR**. Load
`plugins/claudio-dr/references/reviewer-identity.md` before using a publisher.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.

Load `core/issue-authoring/SKILL.md` and follow its referenced contract. Use
`Claudio DR` in the draft summary. When publication is explicitly authorized,
use only the target profile's `create-issue` mode, then verify that the created
issue actor is `claudio-dr[bot]`. If that mode is unavailable, return the
complete draft as `not published`; do not infer that the Claudio DR GitHub App
is inactive.

`gh issue create` and any direct GitHub API call authenticated as the human
user are forbidden for issue creation. There is no fallback to user authorship.
