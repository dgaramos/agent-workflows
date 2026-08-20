# Generic PR review example

Input: `review PR #42 with the default profile`

The reviewer resolves the PR, reports the base/head, inspects the changed code
and relevant callers, records checks consulted, and emits the review summary.
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

The example intentionally contains no project command, credential, or vendor
assumption.
