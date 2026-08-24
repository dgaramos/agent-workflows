# Agent Workflows profile

Use this profile when executing workflows in this repository. Read `AGENTS.md`,
the issue, and `profiles/agent-workflows.md`; run `bin/check` before handoff.

## Delivery metadata

- Labels: `enhancement` plus issue scope labels
- Milestone: `3`
- Assignee: `dgaramos`
- Project: `Agent Workflows` (`11`), status `In Progress`
- Metadata publisher: Cody `.github/workflows/publish-cody-pr-metadata.yml`;
  Claudio `.github/workflows/publish-claudio-pr-metadata.yml`

Never use a personal `gh` session for publisher-backed metadata mutations.
