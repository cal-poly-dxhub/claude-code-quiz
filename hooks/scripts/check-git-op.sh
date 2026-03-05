#!/bin/bash
# Reads the Bash command from hook input and checks if it's a git commit or push.
# If it is and no quiz has been done recently, denies the command so Claude quizzes the user first.
# Uses a temp file as a flag to avoid infinite deny loops.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check if this is a git commit or git push operation
if echo "$COMMAND" | grep -qE 'git\s+(commit|push)(\s|$)'; then
  QUIZ_FLAG="/tmp/claude-quiz-done-$$"

  # Check if quiz was recently completed (within last 120 seconds)
  for f in /tmp/claude-quiz-done-*; do
    if [ -f "$f" ] && [ "$(find "$f" -mmin -2 2>/dev/null)" ]; then
      rm -f "$f"
      exit 0
    fi
  done

  # Create the flag file so the retry goes through
  touch "/tmp/claude-quiz-done-flag"

  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "CODE QUIZ: Before this git operation, you must quiz the developer on their changes. Steps: 1) Run 'git diff --cached' (for commits) or 'git diff origin/HEAD..HEAD' (for pushes) to see the changes. 2) Generate 2-3 questions about the code changes. 3) Use AskUserQuestion to quiz the user one question at a time with multiple choice options. 4) Provide feedback on answers. 5) After the quiz is complete, retry the exact same git command. This is soft enforcement - always retry the command after the quiz regardless of answers."
  }
}
EOF
else
  exit 0
fi
