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

When the user authorizes GitHub publication, a target profile may provide an
external publisher and its documented dispatch contract. Use that publisher;
the personal `gh` session may dispatch it, but must never be switched, refreshed,
logged out, or used to impersonate the reviewer. Wait for the publisher and
verify the resulting review's author and event. Otherwise return publication-
ready comments with publication state `not published`. Never search the target
repository for credentials.

When replying to an existing review thread, use the publisher's documented reply
mode and verify that the reply is authored by the reviewer App in the intended
thread. Do not create a separate review or fall back to a personal `gh` comment.
If the target profile does not document reply mode, return publication-ready
reply text with publication state `not published`.

Resolve a review thread only after confirming the finding is fixed on the current
head. Use the publisher's documented resolution mode, keep an evidence-backed
reply when context requires one, and verify the App resolved the intended thread.
