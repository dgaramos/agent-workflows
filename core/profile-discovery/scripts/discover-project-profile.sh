#!/usr/bin/env bash
set -euo pipefail

root=""
if [[ "${1:-}" == "--root" ]]; then
  root="${2:-}"
  [[ -n "$root" ]] || { echo "--root requires a directory" >&2; exit 64; }
  shift 2
fi
[[ $# -eq 0 ]] || { echo "usage: discover-project-profile.sh [--root DIRECTORY]" >&2; exit 64; }

if [[ -z "$root" ]]; then
  root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi
root="$(cd "$root" && pwd)"

profiles=()
if [[ -d "$root/.agent-review" ]]; then
  while IFS= read -r profile; do
    profiles+=("$profile")
  done < <(find "$root/.agent-review" -mindepth 2 -maxdepth 2 -type f -name PROFILE.md -print | LC_ALL=C sort)
fi

case "${#profiles[@]}" in
  1) printf '%s\n' "${profiles[0]}" ;;
  0) exit 0 ;;
  *) printf 'ambiguous project profiles:\n%s\n' "$(printf '%s\n' "${profiles[@]}")" >&2; exit 3 ;;
esac
