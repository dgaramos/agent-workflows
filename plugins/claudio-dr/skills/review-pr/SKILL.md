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

Discover the target profile from the current repository with
`core/profile-discovery/references/profile-discovery-contract.md` before
applying project-specific rules.

When the target profile declares knowledge sources, load
`core/pr-review/references/knowledge-sources-contract.md` before using them.
Apply its provenance and untrusted-content rules exactly as the portable
contract defines.

When the user authorizes GitHub publication, follow this dispatch sequence:

1. Look up the profile's `review` publisher mode (e.g., `.github/workflows/publish-claudio-review.yml`).
2. Build the manifest: `review_body`, `inline_comments`, `replies`, and `resolve_thread_ids`.
3. Dispatch the workflow via the personal `gh` session (`gh workflow run …` with manifest fields as inputs). Never use `gh pr review` directly — raw CLI posts under the user's personal account, not the reviewer identity.
4. After dispatch, verify the resulting review's author is `claudio-dr[bot]` and the event is `COMMENT`. Any mismatch is a failed publication; do not treat it as a fallback condition.

The personal `gh` session may only dispatch the workflow; it must never be switched, refreshed, logged out, or used to post the review body directly.

If no `review` mode is declared in the target profile, an explicitly authorized
authenticated personal account may post the review via `gh pr review` as a
personal fallback. The outcome must clearly identify the personal GitHub account
as the author and label the action as a personal fallback; never represent it as
`claudio-dr[bot]`.

**Publication event: always `COMMENT`.** Claudio DR never submits `REQUEST_CHANGES` and never submits `APPROVE` — regardless of finding count, profile authorization, or user request. Every publication, including a zero-findings pass, uses `COMMENT`. The publisher is configured for `COMMENT` only; any other event is a contract violation and must not be dispatched.

**Inline findings only.** Every formal finding whose evidence line falls in the
diff must appear as an inline diff comment at the exact `path` and `line` from
the evidence. Do not place findings in the top-level review body as prose.
Findings whose evidence is outside the diff or marked `[general]` go in the
review body, clearly labeled as general observations. Never collapse multiple
inline findings into a single review body paragraph.

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
