# Generic design-to-issue chain

This example shows the portable `design-discovery → author-issue → execute-issue`
chain for a fictional widget dashboard feature in the neutral `acme/widgets`
repository. It uses only illustrative values: a real project profile supplies its
branch convention, quality command, PR metadata, and publisher details.

For the full `execute-issue` lifecycle detail — including implementation and
shipping phases — see [generic-issue-lifecycle.md](generic-issue-lifecycle.md).

---

## Phase 1 — Design discovery

The caller explicitly asks for design discovery on a new widget dashboard feature.
`design-discovery` inspects the supplied evidence, assesses UX impact, and
produces a Design Brief.

### Design Brief

**Context and evidence:** Request to add a real-time widget dashboard to the
`acme/widgets` web app. No existing dashboard UI is available for inspection;
direction is based on the stated need and common patterns for this kind of view.

**Users and problem:** Operations team members who need to monitor widget
processing throughput at a glance. Currently they must open individual widget
detail pages; there is no unified view.

**Flows and states:** Primary flow is dashboard load → widget list renders →
user selects a time range → metrics update. States: loading (skeleton),
empty (no widgets configured), error (data fetch failed), success (metrics
visible), and stale (data older than configured threshold).

**Constraints and unknowns:** Data refresh interval is unknown. No design system
token set has been shared. Mobile breakpoint behavior is not specified.

**Proposed direction:** A grid layout with one card per widget group, each
showing a sparkline and a current-value badge. Selecting a card navigates to
the existing detail page. Time range is controlled by a segmented control in
the page header.

**Proposal representation:** Structured textual layout (no image generation
available in this context). A wireframe or high-fidelity mock would strengthen
the handoff; this limitation is disclosed.

**Accessibility and responsiveness:** Cards must be keyboard-navigable with
visible focus rings. The sparkline must carry an `aria-label` summarizing the
trend for screen readers. Color alone must not encode status — use a text badge
alongside any color indicator. At narrow viewports the grid collapses to a
single column.

**Implementation direction:** Reuse the existing `WidgetCard` component for the
individual card shell. Add a `Sparkline` component accepting a time-series array.
A `useDashboardData` hook handles polling and exposes `{ data, status, error }`.
Acceptance signals: dashboard renders within 2 s on a throttled connection;
empty state shows a call-to-action linking to widget configuration; error state
offers a retry button.

**Success criteria:** Operations team members can assess widget throughput for
the last hour without opening individual detail pages. Error and empty states
are reachable and actionable.

**Handoff:**

```md
## Design discovery handoff

**Problem:** No unified widget throughput view; users open individual detail pages.
**Direction:** Grid dashboard with per-widget sparkline cards and a time-range control.
**Accessibility:** Keyboard navigation, aria-labels on sparklines, no color-only status encoding.
**Responsive behavior:** Single-column collapse below the md breakpoint.
**Assumption:** `WidgetCard` is reusable as the card shell; `useDashboardData` is a new hook.
**Open question:** What is the expected data refresh interval?
**Success signal:** Dashboard renders current-hour throughput in under 2 s on a throttled connection.
```

```md
## Design discovery

**Publication:** not published
```

---

## Phase 2 — Author issue (happy path)

The caller supplies the Design Brief handoff as input to `author-issue`.
`author-issue` incorporates the evidence and UX direction into a structured
issue body and returns a complete draft.

### Issue draft

**Title:** feat(dashboard): add real-time widget dashboard

---

#### Context

Operations team members have no unified view of widget processing throughput.
They must open individual detail pages, which makes situational awareness slow
and error-prone.

#### What to do

- Add a `Dashboard` page at `/dashboard` displaying one card per widget group.
- Implement a `Sparkline` component that accepts a time-series array and an
  accessible label.
- Implement a `useDashboardData` hook that polls the existing metrics endpoint
  and exposes `{ data, status, error }`.
- Add a time-range segmented control in the page header (1 h, 6 h, 24 h).
- Handle loading (skeleton), empty (no widgets), error (fetch failed), and stale
  (data older than threshold) states.
- Ensure keyboard navigation and single-column collapse below the md breakpoint.

#### Expected result

Operations team members can open `/dashboard` and see current widget throughput
for the last hour without visiting individual detail pages. Error and empty states
are reachable and actionable.

#### Acceptance criteria

- [ ] Given the dashboard is open, when data loads, then each widget group shows a sparkline card with a current-value badge within 2 s on a throttled connection.
- [ ] Given the dashboard is open, when no widgets are configured, then the empty state renders a call-to-action linking to widget configuration.
- [ ] Given the dashboard is open, when the metrics fetch fails, then the error state renders a retry button.
- [ ] Given a keyboard user, when navigating the dashboard, then every card receives a visible focus ring and the sparkline has an `aria-label` summarizing the trend.
- [ ] Given a narrow viewport (below md), when the dashboard renders, then cards collapse to a single column.
- [ ] Given the time-range control, when the user selects 6 h or 24 h, then `useDashboardData` re-fetches with the updated range and the cards update.

#### Limitations

- The data refresh interval is not yet defined; `useDashboardData` should use a
  configurable prop defaulting to 30 s until the product decision is made.
- This fixture uses the fictional `acme/widgets` repository and illustrative
  values; it is not executable against a real project without a matching profile.

---

```md
## Issue draft — Claudio DR

**Title:** feat(dashboard): add real-time widget dashboard
**Profile:** acme/widgets
**Profile-owned fields:** applied: labels (enhancement, dashboard), milestone (v2), assignee (maintainer)
**Publication:** not published
```

---

## Phase 2b — Author issue (stopped state)

When the caller has not yet authorized publication, `author-issue` returns the
same complete draft but does not dispatch the `create-issue` publisher. No issue
is created on the remote. The publication line reflects that state, and a prose
note clarifies that explicit authorization is required before any issue is opened.

```md
## Issue draft — Claudio DR

**Title:** feat(dashboard): add real-time widget dashboard
**Profile:** acme/widgets
**Profile-owned fields:** applied: labels (enhancement, dashboard), milestone (v2), assignee (maintainer)
**Publication:** not requested
```

No issue has been created. `author-issue` never calls `gh issue create` or any
direct user-authenticated API; publication requires explicit authorization and a
configured `create-issue` publisher in the target profile. When both conditions
are met, the caller supplies authorization and `author-issue` dispatches the
publisher workflow.

---

## Phase 3 — Execute issue

With the issue created and a matching profile loaded, the caller explicitly
requests execution of the issue. The full `start → plan → implement → ship`
lifecycle proceeds as documented in [generic-issue-lifecycle.md](generic-issue-lifecycle.md).

The execute summary below reflects the outcome of that lifecycle:

```md
## Execute — acme/widgets#99

**Phases completed:** start-issue · plan-implementation · implement-issue · ship-change
**Stopped at:** none
**PR:** https://github.com/acme/widgets/pull/99
```

---

## Parity note — Claudio DR and Cody DR

Both agents follow the same portable contracts for this chain, but differ in
author identity and publisher mechanics:

| Aspect | Claudio DR | Cody DR |
|---|---|---|
| Author identity | `claudio-dr[bot]` | `cody-dr[bot]` |
| Issue creation publisher | `publish-claudio-issue.yml` | `publish-cody-issue.yml` |
| PR metadata publisher | `publish-claudio-pr-metadata.yml` | `publish-cody-pr-metadata.yml` |
| PR review publisher | `publish-claudio-review.yml` | `publish-cody-review.yml` |
| Platform tooling | Claude Code (branch + worktree) | Codex shell and file tools |

The Design Brief, issue draft structure, handoff shape, and execution summary
format are identical across both agents. A reader following this fixture can
substitute either agent's publisher name to adapt the chain to their environment.
