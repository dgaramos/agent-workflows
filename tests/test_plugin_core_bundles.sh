#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root"

bin/sync-plugin-core-bundles.sh --check

temporary_root="$(mktemp -d)"
trap 'rm -rf "$temporary_root"' EXIT

for plugin in cody-dr claudio-dr; do
  artifact_root="$temporary_root/$plugin"
  cp -R "plugins/$plugin" "$artifact_root"

  diff -ru --exclude='.gitkeep' core "$artifact_root/core"

  while IFS= read -r contract_path; do
    test -f "$artifact_root/$contract_path"
  done < <(
    grep -rhoE --include='*.md' 'core/[A-Za-z0-9_./-]+\.(md|sh|yaml)' "plugins/$plugin" \
      | sort -u
  )
done
