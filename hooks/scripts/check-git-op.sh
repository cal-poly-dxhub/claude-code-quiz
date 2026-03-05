#!/bin/bash
# Checks if a Bash command is a git commit/push.
# If so, denies it once so Claude quizzes the user first.
# On retry (within 2 min), allows it through.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'git\s+(commit|push)(\s|$)'; then
  FLAG="/tmp/claude-code-quiz-pass"

  # If flag exists and is less than 2 minutes old, allow the retry
  if [ -f "$FLAG" ] && [ "$(find "$FLAG" -mmin -2 2>/dev/null)" ]; then
    rm -f "$FLAG"
    exit 0
  fi

  # Set the flag so the next attempt goes through
  touch "$FLAG"

  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "CODE QUIZ: Before this git operation, you must quiz the developer on their changes. Steps: 1) Run 'git diff --cached' (for commits) or 'git diff origin/HEAD..HEAD' (for pushes) to see the changes. 2) Generate 2-3 multiple choice questions (A/B/C/D) about the code changes. 3) Display ALL questions at once in a single numbered list with their options. 4) Use a SINGLE AskUserQuestion call asking for all answers at once (e.g. '1:A 2:B 3:C'). Do NOT ask one question at a time. 5) After receiving answers, evaluate all of them together - state correct/incorrect for each with brief explanations. 6) Show final score. 7) Retry the exact same git command. This is soft enforcement - always retry the command after the quiz regardless of answers."
  }
}
EOF
else
  exit 0
fi
