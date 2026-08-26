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
grep -q "$repository_root" "$agents_bin" || { echo "FAIL: agents wrapper does not reference catalog path" >&2; exit 1; }

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

# --force with --status exits non-zero
if run_install "$tmp" --status --force 2>/dev/null; then
  echo "FAIL: expected error for --force with --status, got success" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# --global --force: overwrites a tampered file and prints a warning
# ---------------------------------------------------------------------------
run_install "$tmp" --global >/dev/null 2>&1 || true
echo "tampered" > "$fake_home/.claude/.claude-plugin/plugin.json"

force_output="$(run_install "$tmp" --global --force 2>&1)"
if [[ $? -ne 0 ]]; then
  echo "FAIL: --global --force should exit 0 even on content difference" >&2
  exit 1
fi
echo "$force_output" | grep -q "WARNING" || { echo "FAIL: --force should print a warning for overwritten file" >&2; exit 1; }
actual="$(< "$fake_home/.claude/.claude-plugin/plugin.json")"
expected="$(< "$repository_root/plugins/claudio-dr/.claude-plugin/plugin.json")"
[[ "$actual" == "$expected" ]] || { echo "FAIL: --force did not overwrite the tampered file with catalog content" >&2; exit 1; }

rm -rf "$fake_home/.claude"

# ---------------------------------------------------------------------------
# --global --force: identical files are skipped silently (no WARNING, no error)
# ---------------------------------------------------------------------------
run_install "$tmp" --global >/dev/null 2>&1

force_clean_output="$(run_install "$tmp" --global --force 2>&1)"
echo "$force_clean_output" | grep -q "already current" || { echo "FAIL: --force on identical files should print 'already current'" >&2; exit 1; }
if echo "$force_clean_output" | grep -q "^  WARNING"; then
  echo "FAIL: --force should not print WARNING for identical files" >&2; exit 1
fi

rm -rf "$fake_home/.claude"

# ---------------------------------------------------------------------------
# --repo --force: overwrites a tampered file and exits 0
# ---------------------------------------------------------------------------
(cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --repo >/dev/null 2>&1)
echo "tampered" > "$fake_repo/.claude/.claude-plugin/plugin.json"

repo_force_output="$(cd "$fake_repo" && HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" bash "$repository_root/bin/install" --repo --force 2>&1)"
[[ $? -eq 0 ]] || true  # captured above; verify via content
echo "$repo_force_output" | grep -q "WARNING" || { echo "FAIL: --repo --force should print WARNING" >&2; exit 1; }
repo_actual="$(< "$fake_repo/.claude/.claude-plugin/plugin.json")"
repo_expected="$(< "$repository_root/plugins/claudio-dr/.claude-plugin/plugin.json")"
[[ "$repo_actual" == "$repo_expected" ]] || { echo "FAIL: --repo --force did not overwrite the tampered file" >&2; exit 1; }

echo "bin/install tests passed"
