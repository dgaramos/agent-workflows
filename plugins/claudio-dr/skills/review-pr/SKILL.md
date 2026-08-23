---
description: Claudio DR reviews an explicit pull request, branch, commit range, or local diff with evidence-first findings and incremental re-review. Use for manual PR review or verifying resolved review findings with an optional project profile.
---

# Claudio DR review

Reviewer identity: **Claudio DR**. Load
`plugins/claudio-dr/references/reviewer-identity.md` before using a publisher.

Load `core/pr-review/references/review-contract.md` before reporting. It
defines scope, evidence, confidence, findings, re-review, publication boundary,
post-publication verification, and summary format. Use `Claudio DR` as the
reviewer name in the summary and publication fields.

When the user authorizes GitHub publication, use the publisher documented in the
target profile's dispatch contract. The personal `gh` session may dispatch it,
but must never be switched, refreshed, logged out, or used to impersonate the
reviewer. Wait for the publisher and verify the resulting review's author and
event per the post-publication verification requirements in the review contract.

Build the contract's batched publication manifest: write the portable summary
with walkthrough, evidence-based merge risk, actual pre-merge checks, and a
Mermaid behavior diagram only when it clarifies the change. Place every
changed-line formal finding in its own inline entry,
and batch thread replies and resolutions only after their targets are verified.
Before adding an inline finding, match it against all current human and bot
threads; update an open matching thread with verified current-head evidence.
For re-review, classify every existing thread from current-head evidence; reply
factually with the correction and validation, then resolve only when verified.

When replying to an existing review thread, use the publisher's documented reply
mode and verify that the reply is authored by Claudio DR in the intended thread.
Do not create a separate review or fall back to a personal `gh` comment. If the
target profile does not document reply mode, return publication-ready reply text
as `not published`.

Resolve a review thread only after confirming the finding is fixed on the current
head. Use the publisher's documented resolution mode and verify that Claudio DR
resolved the intended thread. If the target profile does not document resolution
mode, return the prepared reply as `not published`.
