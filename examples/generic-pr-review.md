# Generic PR review example

Input: `review PR #42 with the default profile`

The reviewer loads `core/pr-review/references/review-contract.md` and the target
profile before reviewing. It resolves the PR, reports the base/head, inspects
the changed code and relevant callers, records checks consulted, and emits the
review summary using the contract's summary template with the configured
reviewer name.

For authorized publication it emits one manifest: a summary with a walkthrough,
evidence-based merge risk, actual checks, and a Mermaid behavior diagram when
the interaction warrants one; plus one `{path, line, body}` entry for each diff-bound finding,
and optional reply and resolution batches. General findings stay in the summary;
they never replace valid inline findings.

If a new API response omits a field that existing consumers require, it reports:

```md
API & compatibility · 🟠 Major · 🔧 Focused change

**Preserve the response field required by existing consumers.**

The changed handler omits `next_page`, while the consumer still reads it to
decide whether to request another page.

**Evidence:** `api/handler.py:48` — the response no longer includes `next_page`; confidence: 92/100.
**Impact:** clients can stop pagination early or fail while reading the response.
**Suggested fix:** retain `next_page` or version the contract and update all consumers together.
```

Without publisher authorization, the review body and inline comments are
returned as `not published`. The summary records `Publication: not requested`.

The example intentionally contains no project command, credential, or
vendor assumption. Both Claudio DR and Cody DR produce equivalent scope,
evidence, findings, and summary structure from the same input; they differ only
in reviewer name and platform publisher mechanics.

When a profile enables only review publication, a requested thread reply is
reported as `not published` because the **reply operation** is unavailable. The
reviewer identity itself remains configured and may still publish reviews.
