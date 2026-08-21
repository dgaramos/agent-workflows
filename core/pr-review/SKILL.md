---
name: pr-review
description: Review an explicit pull request, branch, commit range, or local diff with evidence-first findings and incremental re-review. Use for manual code review, cross-model PR review, or verifying resolved review findings; require a project profile for repository-specific rules.
---

# Portable PR review

Review only an explicit PR, branch, commit range, or local diff. Do not infer a
review from unrelated worktree changes and do not publish anything unless the
user explicitly authorizes it.

Load [review-contract](references/review-contract.md) before reporting. It
defines scope, evidence, confidence, findings, re-review, publication boundary,
and summary format. Load [profile-contract](references/profile-contract.md) to
understand what a target profile may and must not provide, including publisher
capability and post-publication verification requirements.
