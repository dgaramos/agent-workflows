# Compatibility model

## Portable contract

The core contract covers explicit PR/ref input, evidence and confidence,
incremental re-review, structured findings, review summaries, and explicit
publication boundaries.

## Adapters

Codex and Claude Code adapters may differ in command names, discovery,
marketplace manifests, agent configuration, and local validation. They must not
change the meaning of the portable review contract without documenting a version
break.

## Profiles

A profile supplies target-repository context such as architecture, security
constraints, quality commands, metadata conventions, and reviewer identity. A
profile can strengthen the core contract but cannot weaken its evidence or
explicit-publication requirements.
