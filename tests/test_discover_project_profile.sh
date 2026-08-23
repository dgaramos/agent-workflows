#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly script="$repository_root/core/profile-discovery/scripts/discover-project-profile.sh"
readonly temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT

if "$script" --root "$temporary_directory" >/dev/null 2>&1; then
  echo "expected no-profile discovery to fail" >&2
  exit 1
fi

mkdir -p "$temporary_directory/.agent-review/example"
touch "$temporary_directory/.agent-review/example/PROFILE.md"
[[ "$("$script" --root "$temporary_directory")" == "$temporary_directory/.agent-review/example/PROFILE.md" ]]

mkdir -p "$temporary_directory/.agent-review/second"
touch "$temporary_directory/.agent-review/second/PROFILE.md"
if "$script" --root "$temporary_directory" >/dev/null 2>&1; then
  echo "expected ambiguous discovery to fail" >&2
  exit 1
fi
