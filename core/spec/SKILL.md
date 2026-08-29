---
name: spec
description: Turn a request into a portable Spec-Driven Development trio—requirements, design, and ordered implementation tasks—without writing or publishing by default.
---

# Portable spec authoring

Load [spec-contract](references/spec-contract.md) before drafting. It defines
the mandatory structure of `requirements.md`, `design.md`, and `tasks.md`, the
executor boundary, and the explicit write and publication boundary.

Load the target project's profile before applying project-specific architecture,
commands, repository locations, or delivery rules. With no profile, create a
portable response only and state that project-specific settings are unknown.

## Steps

1. Detect whether the caller supplied a Design Brief. It is optional context:
   preserve its evidence, constraints, assumptions, open questions, and success
   criteria without treating it as an authorization to write or publish.
2. Classify the request as `feature`, `chore`, `spike`, or `bug`. State the
   classification and investigate the available request and repository evidence
   enough to avoid inventing requirements.
3. Draft the trio in order: `requirements.md`, then `design.md`, then
   `tasks.md`. Follow every required heading and boundary from the spec
   contract. Keep requirement, design, and task terminology consistent.
4. Validate the draft before returning it:
   - every acceptance criterion maps to at least one task;
   - every task names a `Verification:` command or structural validation;
   - task order exposes dependencies and any `## Checkpoint` approval boundary;
   - design decisions are supported by requirements, constraints, or disclosed
     assumptions.
5. When an issue has been created and its body contains a `Spec:` reference,
   add links to the three spec files using the profile-declared repository path.
   Do not create the issue or alter its body without separate explicit
   authorization.
6. Write the trio to a `specs/` repository only when the caller explicitly
   authorizes that exact write and the loaded profile declares the target path.
   Otherwise, return the complete trio in the response and report that it was
   not written.
7. Emit the summary block below.

## Spec summary

```md
## Spec — <request reference>

**Classification:** <feature|chore|spike|bug>
**Design Brief:** <used|not supplied>
**Trio:** `requirements.md`, `design.md`, `tasks.md`
**Traceability:** <every AC mapped to a task; every task has Verification:|limitations>
**Write:** <not requested|not written: reason|written to <path>>
**Issue links:** <not applicable|not added: reason|added to #N>
**Publication:** not published
```

The spec skill never creates an issue, modifies code, writes a repository, or
publishes an artifact by default.
