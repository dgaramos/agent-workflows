# Reviewer identity and publisher capability contract

This contract distinguishes a reviewer from the mechanisms that may publish on
its behalf. It applies to review publication, thread replies, thread resolution,
and issue creation.

## Identity

An adapter defines one reviewer identity with these fields:

- **display name**: the name used in summaries and user-facing output;
- **publisher**: the platform integration allowed to publish for that reviewer;
- **verified actor**: the immutable platform actor expected after publication.

The display name, publisher name, and verified actor are representations of the
same reviewer identity. Do not treat a different display label as a different
reviewer or as permission to fall back to a personal account.

## Capabilities

A profile declares publisher availability independently for each operation:

- `review`
- `reply`
- `resolve-thread`
- `create-issue`

An operation is available only when the profile documents its dispatch inputs
and post-publication verification. If an operation is not available, return the
prepared output as `not published`. Say that the **operation** is unavailable;
do not infer that the reviewer App or integration is inactive.

## Verification

Before publication, the publisher must authenticate as the configured
publisher. After publication, verify the resulting actor, target, and operation
against the profile's reviewer identity. A mismatched actor is a failed
publication, never a fallback.
