# Review reporting contract

## Finding rules

Only formalize findings with confidence `>= 80/100`. Every formal finding needs
current evidence, a concrete impact, and the smallest credible correction. Do
not fabricate tool output, prompts, metrics, or automated fixes.

Choose one category:

| Category | Use for |
| --- | --- |
| `Security & authorization` | Credentials, sessions, authorization, validation, or exposure. |
| `Data integrity & recovery` | Persistence, migration, retention, backup, restore, or history. |
| `API & compatibility` | Public interface, contract, protocol, or compatibility. |
| `Behavior & reliability` | Functional flow, failure behavior, idempotency, or concurrency. |
| `Architecture & maintainability` | Dependency boundary or concrete maintenance risk. |
| `Tests & observability` | Missing behavioral evidence or diagnosability. |
| `Documentation & contribution` | Incorrect public instructions or contributor workflow. |
| `Performance & capacity` | Measurable resource, retention, or scale risk. |

| Class | Badge | Meaning |
| --- | --- | --- |
| `blocking` | `🔴 Critical` | Probable security, data, contract, or material failure; requests change. |
| `important` | `🟠 Major` | Probable regression or incompatibility; requests change. |
| `nit` | `🟡 Minor` | Concrete non-blocking improvement; never requests change. |

Use `⚡ Quick win` for a local change, `🔧 Focused change` for a small
coordinated change, and `🧩 Follow-up` when the correction does not fit the PR.

## Inline or general finding

```md
<category> · <severity badge> · <effort>

**<short imperative title>**

<objective explanation of the failing flow or condition.>

**Evidence:** `<file:line>` — <verified fact>; confidence: <N>/100.
**Impact:** <concrete consequence>.
**Suggested fix:** <smallest credible correction>.
```

Inline findings require a changed line. General findings use `[general]` as the
location and go in the review body.

## Review summary

```md
## Review — <reviewer name>

**Scope:** <PR/ref>, `<base>` → `<head>`
**Reviewed head:** `<sha>`
**Profile:** <profile name or none>
**Checks:** <consulted results>; not run: <reason or none>
**Findings:** 🔴 Critical: N · 🟠 Major: N · 🟡 Minor: N
**Risk axes:** <evaluated>; not applicable: <axes>
**Verdict:** `<approve|request changes|comment|no findings>`
**Publication:** `<not requested|not published|published by reviewer>`
```

With no findings, keep the zero counts and state actual review limitations. Do
not invent a category, effort, or suggested fix.

## Re-review preamble

```md
## Re-review — <PR/ref>

**Previous reviewed head:** `<sha or unavailable>`
**Current head:** `<sha>`
**Delta:** <prior head → current head, or full comparison and reason>
**Previous findings:** resolved: N · fixed but thread open: N · unresolved: N · superseded: N · unverifiable: N
**Discussion checked:** <threads and general comments consulted>
```
