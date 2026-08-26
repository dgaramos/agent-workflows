#!/usr/bin/env bash
set -euo pipefail

readonly repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT

mkdir -p "$temporary_directory/bin"
cat > "$temporary_directory/bin/gh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "$*" >> "$GH_CALL_LOG"
case "$*" in
  *addPullRequestReviewThreadReply*)
    printf '%s\n' '{"data":{"addPullRequestReviewThreadReply":{"comment":{"author":{"login":"cody-dr[bot]"},"pullRequest":{"number":12,"repository":{"nameWithOwner":"octo/example"}}}}}}'
    ;;
  *resolveReviewThread*)
    printf '%s\n' true
    ;;
  *)
    printf '%s\n' '{"data":{"repository":{"pullRequest":{"reviewThreads":{"nodes":[{"id":"thread-one"}],"pageInfo":{"hasNextPage":false,"endCursor":null}}}}}}'
    ;;
esac
EOF
chmod +x "$temporary_directory/bin/gh"

run_action() {
  env \
    GH_TOKEN=test-token \
    GITHUB_REPOSITORY=octo/example \
    PR_NUMBER=12 \
    THREAD_ID=thread-one \
    EXPECTED_AUTHOR='cody-dr[bot]' \
    PUBLISHER_APP_SLUG=cody-dr \
    GH_CALL_LOG="$temporary_directory/gh.log" \
    PATH="$temporary_directory/bin:$PATH" \
    "$@" \
    bash "$repository_root/.github/scripts/publish-cody-thread-action.sh"
}

run_action THREAD_ACTION=reply BODY='Thanks, fixed.'
grep -qF 'addPullRequestReviewThreadReply' "$temporary_directory/gh.log"

run_action THREAD_ACTION=resolve
grep -qF 'resolveReviewThread' "$temporary_directory/gh.log"

if run_action THREAD_ACTION=reply THREAD_ID=thread-mismatch BODY='Must not post.'; then
  echo "reply unexpectedly accepted a thread outside the target PR" >&2
  exit 1
fi
! tail -n 1 "$temporary_directory/gh.log" | grep -qF 'addPullRequestReviewThreadReply'

echo "cody thread action tests passed"
