#!/usr/bin/env bash
# tests/test_update_download.sh — tests for bin/update --download
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

readonly fake_home="$tmp/home"
readonly fake_bin="$tmp/fake-bin"
readonly fake_catalog_store="$fake_home/.local/share/dr-agents"
readonly codex_dir="$fake_home/.codex"

mkdir -p "$fake_home" "$fake_bin" "$fake_catalog_store/tmp" "$codex_dir"

readonly current_ver="v0.9.10"
readonly newer_ver="v0.9.11"

# Stage a fake tarball for the newer version
readonly newer_tarball_name="dr-agents-${newer_ver}.tar.gz"
readonly newer_tarball_path="$fake_catalog_store/tmp/$newer_tarball_name"
readonly newer_sha256_name="dr-agents-${newer_ver}.sha256"
readonly newer_sha256_path="$fake_catalog_store/tmp/$newer_sha256_name"

tar czf "$newer_tarball_path" -C "$repository_root" . 2>/dev/null || true
if command -v sha256sum >/dev/null 2>&1; then
  (cd "$fake_catalog_store/tmp" && sha256sum "$newer_tarball_name" > "$newer_sha256_name")
else
  (cd "$fake_catalog_store/tmp" && shasum -a 256 "$newer_tarball_name" | sed "s|  .*|  $newer_tarball_name|" > "$newer_sha256_name")
fi

# ---------------------------------------------------------------------------
# Create a simulated "current" downloaded install
# ---------------------------------------------------------------------------
current_extract_dir="$fake_catalog_store/$current_ver"
mkdir -p "$current_extract_dir"
# Copy catalog content so bin/install --global works from it
cp -r "$repository_root/plugins" "$current_extract_dir/"
cp -r "$repository_root/bin" "$current_extract_dir/"
# Write a pointer file pointing to the current version
echo "$current_extract_dir" > "$fake_catalog_store/catalog-path"

# ---------------------------------------------------------------------------
# Fake curl stub
# ---------------------------------------------------------------------------
cat > "$fake_bin/curl" <<EOF
#!/usr/bin/env bash
url=""
output_file=""

while [[ \$# -gt 0 ]]; do
  case "\$1" in
    -fsSL|-fsL|-sL|-L|-f|-s|-S) shift ;;
    -o) output_file="\$2"; shift 2 ;;
    http*|https*) url="\$1"; shift ;;
    *) shift ;;
  esac
done

if [[ "\$url" == *"/releases/latest"* ]]; then
  echo '{"tag_name": "${newer_ver}"}'
  exit 0
fi
if [[ "\$url" == *"${newer_tarball_name}"* ]]; then
  [[ -n "\$output_file" ]] && cp "${newer_tarball_path}" "\$output_file" || cat "${newer_tarball_path}"
  exit 0
fi
if [[ "\$url" == *"${newer_sha256_name}"* ]]; then
  [[ -n "\$output_file" ]] && cp "${newer_sha256_path}" "\$output_file" || cat "${newer_sha256_path}"
  exit 0
fi
echo "curl stub: unhandled URL: \$url" >&2
exit 1
EOF
chmod +x "$fake_bin/curl"

run_update() {
  HOME="$fake_home" CODEX_CONFIG_DIR="$codex_dir" PATH="$fake_bin:$PATH" \
    bash "$repository_root/bin/update" "$@" 2>&1
}

# ---------------------------------------------------------------------------
# --download: newer release available → downloads and updates pointer file
# ---------------------------------------------------------------------------
output="$(run_update --download 2>&1)"

newer_extract_dir="$fake_catalog_store/$newer_ver"
[[ -d "$newer_extract_dir" ]] || { echo "FAIL: --download did not extract newer version; output: $output" >&2; exit 1; }

pointer="$(< "$fake_catalog_store/catalog-path")"
[[ "$pointer" == "$newer_extract_dir" ]] || { echo "FAIL: pointer not updated to $newer_ver; got: $pointer" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Previous version directory preserved
# ---------------------------------------------------------------------------
[[ -d "$current_extract_dir" ]] || { echo "FAIL: previous version dir $current_ver was removed" >&2; exit 1; }

# ---------------------------------------------------------------------------
# --download: already at latest → prints "Already at" and exits 0
# ---------------------------------------------------------------------------
# Now pointer points to newer_ver; update curl to return newer_ver as latest
cat > "$fake_bin/curl" <<EOF
#!/usr/bin/env bash
url=""
output_file=""

while [[ \$# -gt 0 ]]; do
  case "\$1" in
    -fsSL|-fsL|-sL|-L|-f|-s|-S) shift ;;
    -o) output_file="\$2"; shift 2 ;;
    http*|https*) url="\$1"; shift ;;
    *) shift ;;
  esac
done

if [[ "\$url" == *"/releases/latest"* ]]; then
  echo '{"tag_name": "${newer_ver}"}'
  exit 0
fi
echo "curl stub: unhandled URL: \$url" >&2
exit 1
EOF

output2="$(run_update --download 2>&1)"
echo "$output2" | grep -qi "already at" || \
  { echo "FAIL: should print 'Already at' when up to date; output: $output2" >&2; exit 1; }

# ---------------------------------------------------------------------------
# --download: no pointer file → exits non-zero with helpful message
# ---------------------------------------------------------------------------
rm -f "$fake_catalog_store/catalog-path"
if run_update --download 2>/dev/null; then
  echo "FAIL: --download without pointer file should exit non-zero" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# bad args: --download with --global exits non-zero
# ---------------------------------------------------------------------------
if run_update --download --global 2>/dev/null; then
  echo "FAIL: --download --global should be rejected" >&2
  exit 1
fi

echo "bin/update --download tests passed"
