#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temp="$(mktemp -d)"
trap 'rm -rf "$temp"' EXIT
mkdir -p "$temp/bin"
log="$temp/gh.log"

cat >"$temp/bin/gh" <<'EOF'
#!/usr/bin/env bash
echo "$*" >>"$TEST_GH_LOG"
case "$1 $2" in
  "api repos/octo/example/milestones/1") echo v1 ;;
  "project view") echo '{"id":"PVT_test","title":"Example project"}' ;;
  "project item-add") echo '{"id":"PVTI_test"}' ;;
  "project field-list") echo '{"fields":[{"id":"PVTSSF_status","name":"Status","options":[{"id":"todo","name":"Todo"},{"id":"progress","name":"In Progress"}]}]}' ;;
  "project item-list") echo '{"items":[{"id":"PVTI_test","status":"In Progress"}]}' ;;
  "pr view") echo '{"baseRefName":"main","labels":[{"name":"enhancement"},{"name":"core"}],"milestone":{"title":"v1"},"assignees":[{"login":"octo"}],"reviewRequests":[{"login":"reviewer"}],"projectItems":[{"title":"Example project"}]}' ;;
esac
EOF
chmod +x "$temp/bin/gh"

TEST_GH_LOG="$log" PATH="$temp/bin:$PATH" "$root/core/issue-workflow/scripts/apply-pr-metadata.sh" \
  --repo octo/example --pr 12 --base main --label enhancement --label core --milestone v1 \
  --assignee octo --reviewer reviewer --project-owner octo --project-number 7 --project-status 'In Progress'

grep -q -- 'pr edit 12 --repo octo/example --add-label enhancement' "$log"
grep -q -- 'pr edit 12 --repo octo/example --milestone v1' "$log"
grep -q -- 'project item-edit --id PVTI_test --project-id PVT_test --field-id PVTSSF_status --single-select-option-id progress' "$log"
grep -q -- 'project item-list 7 --owner octo --limit 1000 --format json' "$log"
echo "apply-pr-metadata tests passed"
