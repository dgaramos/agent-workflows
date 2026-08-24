---
name: author-issue
description: Cody DR drafts a structured GitHub issue and publishes it only with explicit authorization through a configured project publisher.
---

# Cody DR author-issue

Reviewer identity: **Cody DR**. Load
`plugins/cody-dr/references/reviewer-identity.md` before using a publisher.

Discover the target profile first with
`core/profile-discovery/references/profile-discovery-contract.md`.

Load `core/issue-authoring/SKILL.md` and follow its referenced contract,
including the `Publication mechanics` section. Use `Cody DR` in the draft
summary.

When publication is explicitly authorized:

1. Use only the target profile's `create-issue` mode — never a direct GitHub
   API call authenticated as a human user.
2. Pass `title`, `body`, `labels`, `assignees`, and `milestone` as workflow
   inputs. Do not omit profile-declared fields.
3. Conform the issue body to the profile's `.github/ISSUE_TEMPLATE/` structure;
   match every section heading exactly.
4. After the workflow completes, verify the created issue's `author.login` is
   `cody-dr[bot]`. If it is not, mark the issue as `not published` and report
   the mismatch. Do not fall back to user authorship.

If the `create-issue` mode is unavailable, return the complete draft as `not
published`; do not infer that the Cody DR GitHub App is inactive.
