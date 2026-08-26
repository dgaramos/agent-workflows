#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

readonly fake_home="$tmp/home"
readonly fake_repo="$tmp/repo"
readonly codex_dir="$tmp/home/.codex"

# Run bin/install with overridden HOME and CODEX_CONFIG_DIR.
# First arg is the working directory; remaining args are passed to bin/install.
run_install() {
  local workdir="$1"; shift
  HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" \
    bash "$repository_root/bin/install" "$@" 2>&1
}

mkdir -p "$fake_home" "$fake_repo"

# ---------------------------------------------------------------------------
# --global: installs claudio-dr and cody-dr into simulated home directories
# ---------------------------------------------------------------------------
run_install "$tmp" --global

claudio_manifest="$fake_home/.claude/.claude-plugin/plugin.json"
cody_ver="$(jq -r '.version' "$repository_root/plugins/cody-dr/.codex-plugin/plugin.json" 2>/dev/null \
  || grep '"version"' "$repository_root/plugins/cody-dr/.codex-plugin/plugin.json" | head -1 \
  | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')"
cody_manifest="$codex_dir/plugins/cache/cody-dr/${cody_ver}/.codex-plugin/plugin.json"

agents_bin="$fake_home/.local/bin/agents"

[[ -f "$claudio_manifest" ]] || { echo "FAIL: claudio-dr plugin.json not installed" >&2; exit 1; }
[[ -f "$cody_manifest" ]]    || { echo "FAIL: cody-dr plugin.json not installed" >&2; exit 1; }
[[ -f "$agents_bin" ]]       || { echo "FAIL: agents CLI not installed at $agents_bin" >&2; exit 1; }
[[ -x "$agents_bin" ]]       || { echo "FAIL: agents CLI is not executable" >&2; exit 1; }

# ---------------------------------------------------------------------------
# --global: re-run on unchanged files is clean (no conflict)
# ---------------------------------------------------------------------------
run_install "$tmp" --global

# ---------------------------------------------------------------------------
# --global: conflict detected when an existing file differs
# ---------------------------------------------------------------------------
echo "tampered" > "$claudio_manifest"
if run_install "$tmp" --global; then
  echo "FAIL: expected conflict exit on tampered file, got success" >&2
  exit 1
fi

# restore for subsequent tests
rm -rf "$fake_home/.claude"

# ---------------------------------------------------------------------------
# --repo: installs claudio-dr into a local .claude/ directory
# ---------------------------------------------------------------------------
(cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --repo >/dev/null)

repo_manifest="$fake_repo/.claude/.claude-plugin/plugin.json"
[[ -f "$repo_manifest" ]] || { echo "FAIL: repo claudio-dr plugin.json not installed" >&2; exit 1; }

# ---------------------------------------------------------------------------
# --repo --profile: copies the named profile file
# ---------------------------------------------------------------------------
(cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --repo --profile agent-workflows >/dev/null)

profile_dest="$fake_repo/.claude/profiles/agent-workflows.md"
[[ -f "$profile_dest" ]] || { echo "FAIL: profile not installed at $profile_dest" >&2; exit 1; }

# ---------------------------------------------------------------------------
# --repo --profile: unknown profile exits non-zero
# ---------------------------------------------------------------------------
if (cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --repo --profile no-such-profile 2>/dev/null); then
  echo "FAIL: expected failure for unknown profile, got success" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# --status: runs without error and reports both plugins
# ---------------------------------------------------------------------------
status_output="$(cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --status 2>&1)"
echo "$status_output" | grep -q "claudio-dr" || { echo "FAIL: status output missing claudio-dr" >&2; exit 1; }
echo "$status_output" | grep -q "cody-dr"    || { echo "FAIL: status output missing cody-dr" >&2; exit 1; }
echo "$status_output" | grep -q "agents"     || { echo "FAIL: status output missing agents" >&2; exit 1; }

# ---------------------------------------------------------------------------
# bad args: no mode exits non-zero
# ---------------------------------------------------------------------------
if run_install "$tmp" 2>/dev/null; then
  echo "FAIL: expected usage error with no args, got success" >&2
  exit 1
fi

# --profile without --repo exits non-zero
if run_install "$tmp" --profile agent-workflows 2>/dev/null; then
  echo "FAIL: expected error for --profile without --repo, got success" >&2
  exit 1
fi

echo "bin/install tests passed"
