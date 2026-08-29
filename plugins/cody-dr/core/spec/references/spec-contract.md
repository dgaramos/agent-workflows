# Spec-Driven Development contract

## Purpose

Spec-Driven Development (SDD) turns a feature request into a portable,
machine-readable trio of documents before issue authoring or implementation.
The trio consists of `requirements.md`, `design.md`, and `tasks.md`. A spec
agent must create the documents in that order and keep their terminology and
acceptance criteria aligned.

The contract is portable. It defines document structure and workflow behavior,
not a target project's architecture, commands, credentials, issue metadata, or
deployment policy.

When a profile declares an external spec source, it must use the exact
`## Spec source` convention from the profile-discovery contract. The declaration
authorizes resolving only its exact trio path; a missing, partial, ambiguous, or
inaccessible declaration never authorizes inference of an alternate source.

The portable spec-authoring entrypoint is `core/spec/SKILL.md`. Adapter
bindings are deliberately deferred to their dedicated follow-up issues.

## `requirements.md`

`requirements.md` must contain these headings in this order:

1. `## Objetivo` — the user or system outcome.
2. `## Requisitos funcionais` — observable capabilities and rules.
3. `## Requisitos não-funcionais` — applicable quality, security,
   accessibility, performance, compatibility, and operational constraints.
4. `## Critérios de aceite` — independently verifiable criteria in
   Given/When/Then form. Every criterion must state the expected failure state
   when the relevant condition fails.
5. `## Condições de falha` — failure modes, user-visible behavior, recovery,
   and any escalation path.
6. `## Boundaries` — a table using `✅`, `⚠️`, and `🚫` to distinguish included,
   uncertain, and excluded scope.

Do not invent facts that are absent from the request or loaded profile. Record
assumptions and unknowns in the relevant requirement or boundary row.

## `design.md`

`design.md` must contain these headings in this order:

1. `## Stack` — relevant technologies and constraints, or an explicit
   statement that they are unknown.
2. `## Arquitetura` — a Mermaid diagram plus a concise description of
   component responsibilities and data/control flow.
3. `## Contratos de componente` — component inputs, outputs, invariants,
   errors, and ownership boundaries.
4. `## Estratégia de teste` — coverage needed for the acceptance criteria,
   including failure paths and the strongest available validation for
   non-executable work.

The design must trace each significant component decision to a requirement or
constraint. It must not add implementation scope that the requirements exclude.

## `tasks.md`

`tasks.md` must express implementation work as ordered Markdown checkbox tasks.
Each task must include a nested `Verification:` sub-item naming the exact
command or structural check that demonstrates completion. Tasks may be grouped
under optional `## Checkpoint` headings; a checkpoint names the decision or
approval boundary before later tasks proceed.

Every acceptance criterion in `requirements.md` must map to one or more tasks,
and every task must be justified by a requirement, constraint, or necessary
validation activity. The task sequence must make dependencies explicit.

## Executor boundary

For an executor, tasks.md is read-only execution input. The executor reads
tasks in order, runs each task's `Verification:` command after completing that
task, and does not rewrite the spec as part of implementation. At a
`## Checkpoint`, the executor stops for approval unless the caller explicitly
authorized continuous execution.

## Publication boundary

Drafting a spec does not authorize creating an issue, writing to an external
`specs/` repository, publishing artifacts, changing code, or opening a pull
request. A spec is written outside the current response only when the caller
explicitly authorizes that exact write and the loaded profile declares the
target path.

**Publication:** not published unless that explicit write authorization and profile-declared target are present.
