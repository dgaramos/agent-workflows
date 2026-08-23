#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temp="$(mktemp -d)"
trap 'rm -rf "$temp"' EXIT
mkdir -p "$temp/bin" "$temp/core/issue-workflow/scripts"
log="$temp/log"

cat >"$temp/bin/gh" <<'EOF'
#!/usr/bin/env bash
echo "$*" >>"$TEST_LOG"
[[ "$1 $2" == "api user" ]] && echo cody-dr'[bot]'
EOF
chmod +x "$temp/bin/gh"
cat >"$temp/core/issue-workflow/scripts/apply-pr-metadata.sh" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$TEST_LOG"
EOF
chmod +x "$temp/core/issue-workflow/scripts/apply-pr-metadata.sh"

cd "$temp"
TEST_LOG="$log" PATH="$temp/bin:$PATH" GITHUB_REPOSITORY=octo/example \
  PR_NUMBER=12 BASE_BRANCH=main LABELS_JSON='["enhancement","core"]' \
  ASSIGNEES_JSON='["octo"]' MILESTONE_NUMBER=3 PROJECT_OWNER=octo \
  PROJECT_NUMBER=7 PROJECT_STATUS='In Progress' EXPECTED_AUTHOR='cody-dr[bot]' \
  bash "$root/.github/scripts/publish-pr-metadata.sh"

grep -q -- 'api user --jq .login' "$log"
grep -q -- '--repo octo/example --pr 12 --base main --label enhancement --label core --assignee octo --milestone 3 --project-owner octo --project-number 7 --project-status In Progress' "$log"
echo "publish-pr-metadata tests passed"
