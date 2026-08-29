# Generic design-discovery example

Input: `Users abandon checkout when a discount code is invalid. Propose a better experience. No screenshots or image-generation capability are available.`

The designer loads the portable design-discovery contract and any available
profile. It treats the reported abandonment as supplied context, not proof of a
specific cause, and returns an initial direction rather than claiming knowledge
of an existing UI.

Example proposal representation:

```text
Checkout summary
┌─────────────────────────────────────┐
│ Discount code [____________] [Apply]│
│                                     │
│ Invalid code. Check spelling or try │
│ another code.                       │
│                                     │
│ Total                               │
│ [Continue to payment]               │
└─────────────────────────────────────┘
```

Example handoff:

```md
## Design Brief handoff

**Problem:** An invalid discount code should not leave the customer uncertain
about whether checkout can continue.
**Direction:** Preserve the entered code, place concise error guidance adjacent
to the input, and keep the payment action available unless another validation
error blocks checkout.
**Accessibility:** Expose the error through the input description, move focus
only when the user submits the invalid field, and retain sufficient contrast.
**Responsive behavior:** Keep the code input and Apply action usable at narrow
widths by stacking the action below the input when needed.
**Open question:** Confirm whether support can provide a recovery path for
expired codes.
**Success signal:** Fewer repeated code submissions and checkout continuation
after an invalid-code response.
```

The output ends with `Publication: not published`. It does not create an issue
or upload the wireframe. The issue author can include the handoff as context
when an issue is explicitly authored, or a spec agent can use it as optional
input when drafting the portable spec trio.

## Profile design rules example

When a project declares design-specific rules in its profile, the designer
loads those rules before producing the brief. A maintainer can copy and adapt
the following fields:

```md
## Design rules

- **Component library:** <e.g. Material UI 5, Tailwind CSS, custom design system>
- **Accessibility standard:** <e.g. WCAG 2.1 AA — all interactive elements must meet this baseline>
- **Breakpoints:** <e.g. mobile ≤ 480 px, tablet 481–1024 px, desktop > 1024 px>
- **Motion policy:** <e.g. respect prefers-reduced-motion; avoid autoplay animations>
- **Color tokens:** <e.g. reference tokens from design-system/tokens.json; never hardcode hex values>
- **Keyboard and focus policy:** <e.g. all interactive elements must be reachable via Tab; visible focus indicators required>
- **Open questions to escalate:** <e.g. brand approval required for new color roles>
```

These fields are consumed by the designer when the profile is discovered. They
strengthen the brief's **Constraints and unknowns** and **Accessibility and
responsiveness** sections without requiring manual re-entry on every invocation.
Fields not declared in the profile are treated as unknown; the designer states
the assumption and lists the open question rather than inventing values.
