# Project profile discovery contract

Before a project-aware workflow starts, establish the repository root from the
current working directory and inspect exactly this location:

```text
<repository-root>/.agent-review/*/PROFILE.md
```

Use `core/profile-discovery/scripts/discover-project-profile.sh` when the
catalog checkout is available. It prints the sole matching profile path.

- One match: load that profile before applying project-specific behavior.
- No match: continue with generic portable rules. Do not invent project-specific
  commands, metadata, or publishers. Issue execution still authorizes normal
  delivery actions; review and comment publication remain explicit.
- More than one match: stop and ask the caller to name the intended profile;
  never choose one by directory order.

Profiles are target-project data. Do not copy them into plugins, core, or a
global agent. A wrapper may name an explicit profile for backwards
compatibility, but must not prevent this discovery procedure for new projects.
