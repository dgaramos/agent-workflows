# Generic test-first implementation planning

`plan-implementation` is a read-only phase. For issue `#42` in the neutral
`acme/widgets` repository, it inspects the issue, profile, source, and existing
tests, then prints a plan immediately. It does not request confirmation,
create a branch, or modify files.

```md
## Implementation plan — #42

**Profile:** `acme/widgets`
**Dependencies:** resolved
**Scope:** reject expired widget-cache tokens
**Out of scope:** token issuance and cache storage

### Criterion — expired tokens are rejected

**Files:** `src/tokens/validate.ts`, `tests/tokens/validate.test.ts`
**TDD:** Red → Green → Refactor
**Coverage:** valid-token happy path; expired-token failure; expiry-at-now edge
case; cached-valid-token regression
**Steps:**
1. **Red:** add an expired-token test and run `npm test -- validate.test.ts`;
   record the expected failure.
2. **Green:** add the smallest expiry comparison and rerun the focused test.
3. **Refactor:** improve names only if needed, then run `npm test`.

### Criterion — document the endpoint

**Files:** `README.md`
**TDD:** Not applicable: prose has no executable behavior
**Coverage:** README link and catalog structure validation
**Steps:**
1. Update the endpoint description.
2. Run `bin/check` as the strongest available structural validation.

**Risks and assumptions:** server time is the expiry authority.
**Validation order:** `npm test -- validate.test.ts`, `npm test`, `bin/check`
**Next:** implement-issue
```

An unresolved dependency remains visible in the printed plan and blocks later
implementation; it never hides the plan behind a confirmation prompt.
