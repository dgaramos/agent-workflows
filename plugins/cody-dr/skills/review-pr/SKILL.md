---
name: review-pr
description: Cody DR reviews an explicit pull request, branch, commit range, or local diff with evidence-first findings and incremental re-review. Use for manual PR review or verifying resolved review findings with an optional project profile.
---

# Cody DR review

Require an explicit reference and load the target project's profile before
reviewing. Do not infer a review from unrelated local changes and do not run
automatically after implementation.

Load `references/review-contract.md` before reporting. It defines scope,
evidence, confidence, re-review, findings, summary, and publication rules.

When the user authorizes GitHub publication, use only an external publisher
already configured outside the target repository. Otherwise return publication-
ready comments with publication state `not published`. Never search the target
repository for credentials.
