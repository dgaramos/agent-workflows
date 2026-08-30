# Generic spec clarification example

An authorized trio says notifications are retried but does not define a retry
limit. `clarify-spec` reports the ambiguity rather than changing the trio.

```md
## Spec clarification — acme/specs/specs/billing/overdue-invoice-notifications/

**Source:** authorized location
**Status:** needs decisions
### Decision — retry limit
**Evidence:** requirements.md requires retries; design.md has no limit.
**Proposed default:** retry at most three times with the host project's delay.
**Destination after approval:** requirements.md
**Write:** not authorized
```

With no authorized source, the result is `Source: unavailable: no exact
profile-declared path`; it does not guess a repository or write a default.
