#!/usr/bin/env bash
set -euo pipefail

# Core remains the only editable source for portable contracts. Plugin-local
# copies are distribution artifacts because marketplace installations contain
# only the selected plugin directory.
readonly source_dir="core"
readonly plugin_dirs=(
  "plugins/cody-dr"
  "plugins/claudio-dr"
)

if [[ "${1:-}" == "--check" ]]; then
  for plugin_dir in "${plugin_dirs[@]}"; do
    if ! diff -ru --exclude='.gitkeep' "$source_dir" "$plugin_dir/core"; then
      echo "core bundle drift: $plugin_dir/core must match $source_dir" >&2
      exit 1
    fi
  done
  exit 0
fi

if [[ $# -ne 0 ]]; then
  echo "usage: $0 [--check]" >&2
  exit 2
fi

for plugin_dir in "${plugin_dirs[@]}"; do
  mkdir -p "$plugin_dir/core"
  rsync -a --delete --exclude='.gitkeep' "$source_dir/" "$plugin_dir/core/"
done
