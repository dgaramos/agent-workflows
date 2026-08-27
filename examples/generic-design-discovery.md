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
when an issue is explicitly authored.
