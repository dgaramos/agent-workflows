---
name: author-issue
description: Draft and optionally publish a well-structured GitHub issue. Produces a context, acceptance-criteria, and dependency-complete draft first; publishes only when explicitly authorized and a profile publisher is available.
---

# Portable issue authoring

Load [issue-contract](references/issue-contract.md) before drafting. It defines
the required issue structure, draft-first behavior, profile-owned fields, the
publication boundary, and the post-publication verification requirement.

Load the target project's profile before authoring. The profile supplies labels,
assignees, milestones, Projects, and any repository issue template to apply. A
missing profile means authoring proceeds with body only; state that limitation
in the draft summary.

Do not publish the issue or request external state changes until the user
explicitly authorizes it.
