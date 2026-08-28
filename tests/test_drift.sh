#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly script="$repository_root/bin/drift"
readonly tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# ---------------------------------------------------------------------------
# Fixture catalog: a minimal directory that looks like the catalog root.
# We create just enough structure for bin/drift to self-detect it.
# ---------------------------------------------------------------------------
setup_catalog() {
  local catalog="$1"
  mkdir -p "$catalog/core/some-skill/references"
  touch "$catalog/core/some-skill/references/contract.md"
  # Marker file so CWD self-detection works
  touch "$catalog/bin/check"
  mkdir -p "$catalog/bin"
  touch "$catalog/profiles"
}

# ---------------------------------------------------------------------------
# Test 1: valid-reference exits 0 with "profile drift check: ok"
# A profile that references core/some-skill/references/contract.md which exists.
# ---------------------------------------------------------------------------
catalog1="$tmpdir/catalog1"
mkdir -p "$catalog1/core/some-skill/references"
touch "$catalog1/core/some-skill/references/contract.md"
mkdir -p "$catalog1/profiles"
mkdir -p "$catalog1/bin"
touch "$catalog1/bin/check"

profile1="$catalog1/profiles/valid.md"
cat > "$profile1" <<'EOF'
# Valid profile

Load `core/some-skill/references/contract.md` before acting.
EOF

output1="$(AGENT_WORKFLOWS_DIR="$catalog1" "$script" 2>&1)"
if ! echo "$output1" | grep -q "profile drift check: ok"; then
  echo "FAIL test 1: expected 'profile drift check: ok', got: $output1" >&2
  exit 1
fi
echo "PASS test 1: valid reference exits 0 with expected message"

# ---------------------------------------------------------------------------
# Test 2: missing-reference exits 1 with expected violation message
# A profile that references core/missing/path.md which does not exist.
# ---------------------------------------------------------------------------
catalog2="$tmpdir/catalog2"
mkdir -p "$catalog2/profiles"
mkdir -p "$catalog2/bin"
touch "$catalog2/bin/check"

profile2="$catalog2/profiles/broken.md"
cat > "$profile2" <<'EOF'
# Broken profile

Load `core/missing/path.md` before acting.
Also see core/another/missing.md for details.
EOF

if AGENT_WORKFLOWS_DIR="$catalog2" "$script" 2>&1; then
  echo "FAIL test 2: expected non-zero exit for missing reference" >&2
  exit 1
fi
output2="$(AGENT_WORKFLOWS_DIR="$catalog2" "$script" 2>&1 || true)"
if ! echo "$output2" | grep -q "drift: .*broken.md references core/missing/path.md"; then
  echo "FAIL test 2: expected violation message for core/missing/path.md, got: $output2" >&2
  exit 1
fi
if ! echo "$output2" | grep -q "drift: .*broken.md references core/another/missing.md"; then
  echo "FAIL test 2: expected violation message for core/another/missing.md, got: $output2" >&2
  exit 1
fi
echo "PASS test 2: missing reference exits 1 with violation message"

# ---------------------------------------------------------------------------
# Test 3: no-catalog exits 0 with a warning naming all three discovery methods
# Run from a temp dir with no env var, no CWD catalog marker, no pointer file.
# ---------------------------------------------------------------------------
catalog3="$tmpdir/nocatalog"
mkdir -p "$catalog3"
# Temporarily override HOME to avoid picking up a real pointer file
output3="$(cd "$catalog3" && HOME="$tmpdir/fakehome" AGENT_WORKFLOWS_DIR="" "$script" 2>&1 || true)"
exit_code3=0
cd "$catalog3" && HOME="$tmpdir/fakehome" AGENT_WORKFLOWS_DIR="" "$script" >/dev/null 2>&1 || exit_code3=$?
if [[ "$exit_code3" -ne 0 ]]; then
  echo "FAIL test 3: expected exit 0 when no catalog is locatable, got exit $exit_code3" >&2
  exit 1
fi
# Check that the warning names all three discovery methods
for keyword in "AGENT_WORKFLOWS_DIR" "catalog-path" "bin/check"; do
  if ! echo "$output3" | grep -q "$keyword"; then
    echo "FAIL test 3: warning does not mention '$keyword', got: $output3" >&2
    exit 1
  fi
done
echo "PASS test 3: no-catalog exits 0 with warning naming all three discovery methods"

echo ""
echo "All drift tests passed."
