#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for helper in \
  "$repository_root/plugins/claudio-dr/agents/claudio-helper.md" \
  "$repository_root/plugins/cody-dr/agents/cody-helper.md"; do
  content="$(<"$helper")"
  for required in \
    'Mode 1' \
    'Mode 2' \
    'Mode 3' \
    '.dr-agents/*/PROFILE.md' \
    'bin/install --repo' \
    'bin/install --status' \
    'agents download' \
    'AGENTS.md' \
    'Cody DR'; do
    if [[ "$content" != *"$required"* ]]; then
      echo "FAIL: $(basename "$helper") is missing required helper behavior: $required" >&2
      exit 1
    fi
  done
done

echo "helper agent tests passed"
