#!/usr/bin/env bash
set -euo pipefail

: "${PR_NUMBER:?PR_NUMBER is required}"
: "${BASE_BRANCH:?BASE_BRANCH is required}"
: "${EXPECTED_AUTHOR:?EXPECTED_AUTHOR is required}"
: "${PUBLISHER_APP_SLUG:?PUBLISHER_APP_SLUG is required}"

[[ "$PUBLISHER_APP_SLUG" == "${EXPECTED_AUTHOR%\[bot\]}" ]] || {
  echo "unexpected authenticated app" >&2
  exit 1
}

mapfile -t labels < <(jq -er '.[] | strings | select(length > 0)' <<<"${LABELS_JSON:-[]}")
mapfile -t assignees < <(jq -er '.[] | strings | select(length > 0)' <<<"${ASSIGNEES_JSON:-[]}")

args=(
  --repo "$GITHUB_REPOSITORY"
  --pr "$PR_NUMBER"
  --base "$BASE_BRANCH"
)
for label in "${labels[@]}"; do args+=(--label "$label"); done
for assignee in "${assignees[@]}"; do args+=(--assignee "$assignee"); done
[[ -z "${MILESTONE_NUMBER:-}" ]] || args+=(--milestone "$MILESTONE_NUMBER")

if [[ -n "${PROJECT_OWNER:-}${PROJECT_NUMBER:-}${PROJECT_STATUS:-}" ]]; then
  [[ -n "${PROJECT_OWNER:-}" && -n "${PROJECT_NUMBER:-}" && -n "${PROJECT_STATUS:-}" ]] || {
    echo "project owner, number, and status must be supplied together" >&2
    exit 2
  }
  args+=(--project-owner "$PROJECT_OWNER" --project-number "$PROJECT_NUMBER" --project-status "$PROJECT_STATUS")
fi

bash core/issue-workflow/scripts/apply-pr-metadata.sh "${args[@]}"
