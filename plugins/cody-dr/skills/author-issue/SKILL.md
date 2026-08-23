---
name: author-issue
description: Cody DR drafts a structured GitHub issue and publishes it only with explicit authorization through a configured project publisher.
---

# Cody DR author-issue

Reviewer identity: **Cody DR**. Load
`plugins/cody-dr/references/reviewer-identity.md` before using a publisher.

Load `core/issue-authoring/SKILL.md` and follow its referenced contract. Use
`Cody DR` in the draft summary. When publication is explicitly authorized, use
only the target profile's `create-issue` mode, then verify that the created
issue actor is `cody-dr[bot]`. If that mode is unavailable, return the complete
draft as `not published`; do not infer that the Cody DR GitHub App is inactive.
