---
name: pr-review
description: Review an explicit pull request, branch, commit range, or local diff with evidence-first findings and incremental re-review. Use for manual code review, cross-model PR review, or verifying resolved review findings; require a project profile for repository-specific rules.
---

# Portable PR review

Review only an explicit PR, branch, commit range, or local diff. Do not infer a
review from unrelated worktree changes and do not publish anything unless the
user explicitly authorizes it.

## Inputs and context

1. Resolve the requested reference, base, head SHA, changed files, issue or PR
   intent, checks, and existing review discussion.
2. Load the target project's profile before evaluating the diff. A missing
   profile means review only generic correctness, security, compatibility, and
   evidence; state that limitation in the summary.
3. Read changed code with its callers, tests, and public contract. Do not treat
   a diff in isolation as proof of behavior.

For local work, report which staged, unstaged, and untracked changes were in
scope. Do not attribute unrelated files to the requested review.

## Evidence and findings

Load [reporting](references/reporting.md) before writing findings. Use its
taxonomy and templates exactly. A formal finding needs all of:

- a current `file:line` or an explicit general-review location;
- a reproducible flow or factual evidence;
- concrete impact;
- confidence of at least `80/100`.

Put lower-confidence hypotheses only in the summary as limitations or
observations. Do not use style preference as a finding. A `nit` never justifies
requesting changes.

## Re-review

When reviewing a PR again after changes, load all current threads, top-level
comments, reviews, and their states. Locate the last head reviewed by the same
reviewer.

1. If the prior SHA is trustworthy and ancestral to the current head, inspect
   the diff from prior head to current head for new findings.
2. Otherwise, declare the delta unverifiable and review the full current
   base-to-head comparison.
3. Validate each previous finding against the current code and classify it as
   `resolved`, `fixed but thread open`, `unresolved`, `superseded`, or
   `unverifiable`.
4. Treat replies as context, never proof. Do not repeat resolved findings;
   report a regression introduced by a fix as a new finding.

Use the re-review preamble in [reporting](references/reporting.md) before the
new-findings section.

## Publication boundary

Prepare a review body and inline comments only after verifying the current head.
Publish, reply, resolve threads, approve, or request changes only when the user
explicitly asks and the target profile provides an external publisher. Never
look for credentials in the target repository. Without a publisher, return the
same formatted content as `not published`.

## Output

Use the summary template in [reporting](references/reporting.md) once per
review. It records reference, base/head, reviewed head, scope, checks, findings
by severity, risk axes, verdict, publication state, and actual limitations.
