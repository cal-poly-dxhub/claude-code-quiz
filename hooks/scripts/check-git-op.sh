#!/bin/bash
# Reads the Bash command from hook input and checks if it's a git commit or push.
# If it is, returns ok:false so Claude gets prompted to quiz the user.
# If not, exits 0 silently to let the command proceed.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check if this is a git commit or git push operation
if echo "$COMMAND" | grep -qE 'git\s+(commit|push)(\s|$)'; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "IMPORTANT: Before executing this git commit/push, you MUST quiz the developer on their code changes first. Run 'git diff --cached' (for commits) or 'git log origin/HEAD..HEAD' (for pushes) to see the changes, generate 2-3 targeted questions about the code, and use the AskUserQuestion tool to quiz the user. After the quiz, provide brief feedback, then proceed with the original git command. This is soft enforcement - always allow the operation after the quiz."
  }
}
EOF
else
  exit 0
fi
