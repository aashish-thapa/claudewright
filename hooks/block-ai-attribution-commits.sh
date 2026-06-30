#!/usr/bin/env bash
# claudewright: PreToolUse hook for Bash that denies `git commit` invocations
# whose message contains an AI-attribution footer.
set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

if ! printf '%s' "$cmd" | grep -qE '(^|[[:space:];&|(])git[[:space:]]+commit'; then
  exit 0
fi

if printf '%s' "$cmd" | grep -qiE 'co-authored-by:[[:space:]]*claude|generated with .{0,4}claude code|🤖 generated with'; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Commit message contains an AI-attribution footer (Co-Authored-By: Claude or Generated with Claude Code). Strip the footer and retry the commit. This rule is enforced by the claudewright plugin."}}
JSON
fi

exit 0
