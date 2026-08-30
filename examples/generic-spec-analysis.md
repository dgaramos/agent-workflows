# Generic spec analysis example

`analyze-spec` reads an authorized trio without changing it.

```md
## Spec analysis — acme/specs/specs/billing/overdue-invoice-notifications/

**Source:** authorized location
**Readiness:** ready
**Criterion coverage:** AC-01 → T01, T02
**Verification coverage:** T01 and T02 each declare a safe Verification command
**Conflicts:** none
**Boundaries:** satisfied
**Checkpoints:** ready
**Publication:** not published
```

A legacy trio is reported as `Criterion coverage: unavailable: legacy format`;
the analyzer never invents links.
