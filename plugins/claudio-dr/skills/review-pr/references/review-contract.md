# Portable review contract

Collect the explicit PR/ref, base, current head, changed files, relevant issue,
checks, and review discussion. Load a project profile when available; otherwise
review generic correctness, security, compatibility, and evidence only.

Formal findings require current `file:line` evidence, a reproducible flow or
fact, concrete impact, and confidence `>= 80/100`. Use one category and one
class:

| Category | Examples |
| --- | --- |
| Security & authorization | validation, sessions, credentials |
| Data integrity & recovery | persistence, migration, backup |
| API & compatibility | public interface or protocol |
| Behavior & reliability | flow, failure, idempotency |
| Architecture & maintainability | concrete boundary risk |
| Tests & observability | missing behavioral evidence |
| Documentation & contribution | incorrect public instruction |
| Performance & capacity | measurable scale or resource risk |

| Class | Badge | Meaning |
| --- | --- | --- |
| blocking | 🔴 Critical | material security, data, contract, or failure risk |
| important | 🟠 Major | probable regression or incompatibility |
| nit | 🟡 Minor | concrete non-blocking improvement |

```md
<category> · <badge> · <⚡ Quick win|🔧 Focused change|🧩 Follow-up>

**<short imperative title>**

<objective explanation>

**Evidence:** `<file:line>` — <fact>; confidence: <N>/100.
**Impact:** <concrete consequence>.
**Suggested fix:** <smallest credible correction>.
```

For a re-review, locate the last reviewed head. If it is ancestral to current
head, review only that delta for new findings and classify previous findings as
resolved, fixed but thread open, unresolved, superseded, or unverifiable. If
the SHA is missing or history was rewritten, declare the delta unverifiable and
review the full comparison. Thread replies are context, not proof.

Emit one summary per review:

```md
## Review — Claudio DR

**Scope:** <PR/ref>, `<base>` → `<head>`
**Reviewed head:** `<sha>`
**Profile:** <name or none>
**Checks:** <results>; not run: <reason or none>
**Findings:** 🔴 Critical: N · 🟠 Major: N · 🟡 Minor: N
**Risk axes:** <evaluated>; not applicable: <axes>
**Verdict:** `<approve|request changes|comment|no findings>`
**Publication:** `<not requested|not published|published by Claudio DR>`
```
