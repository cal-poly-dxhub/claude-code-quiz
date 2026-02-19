# Claude Code Quiz

A plugin for [Claude Code](https://github.com/anthropics/claude-code) that quizzes developers on their code changes before committing or pushing.

## Why?

Designed to combat "vibe coding" - when developers push code without fully understanding what it does. This plugin helps ensure you actually comprehend the changes you're committing.

## Features

### 1. Voluntary Quiz (`/quiz`)

Test yourself on recent code changes at any time:

```
/quiz
```

Analyzes your uncommitted changes (or last commit if working tree is clean) and generates 3-5 questions to test your understanding.

### 2. Pre-Commit/Push Hook

Automatically prompts you with 2-3 questions before any `git commit` or `git push` operation.

**Soft enforcement** - you'll see the quiz and get feedback, but the operation proceeds regardless of your answers. The goal is awareness, not blocking.

## Installation

### Option 1: Clone and install locally

```bash
git clone https://github.com/swayamchidrawar/claude-code-quiz.git
```

Then in Claude Code:

```
/plugin install /path/to/claude-code-quiz
```

### Option 2: Install directly from GitHub

```
/plugin install https://github.com/swayamchidrawar/claude-code-quiz
```

### Option 3: Add to settings

Add to your Claude Code settings file (`~/.claude/settings.json`):

```json
{
  "plugins": [
    "https://github.com/swayamchidrawar/claude-code-quiz"
  ]
}
```

## Usage

### Voluntary Quiz

```
> /quiz

Analyzing your recent changes...

Question 1/3: What does the validateInput function return when given an empty string?
A) null
B) false
C) throws an error
D) empty string

[Select answer]

Correct! The function returns false for empty strings as shown on line 12.
```

### Pre-Commit Quiz

```
> git commit -m "Add validation"

Before committing, let's verify your understanding:

Question 1/2: Why does the regex pattern include the '+' quantifier?
[...]

Quiz complete! Proceeding with commit.
```

## How It Works

### Hook Mechanism

The PreToolUse hook intercepts Bash commands and checks for git commit/push operations. When detected, Claude:

1. Analyzes the staged changes
2. Generates relevant questions about the code
3. Quizzes you interactively
4. Provides feedback on your answers
5. Allows the operation to proceed

### Quiz Skill

The `/quiz` skill:

1. Checks for uncommitted changes or analyzes last commit
2. Generates 3-5 comprehension questions
3. Presents multiple choice questions
4. Explains correct answers with code references

## File Structure

```
claude-code-quiz/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── hooks/
│   └── hooks.json           # PreToolUse hook for git operations
├── skills/
│   └── quiz/
│       └── SKILL.md         # Voluntary /quiz command
└── README.md
```

## Customization

### Adjust Question Count

Edit `hooks/hooks.json` and change "2-3 questions" to your preferred number.

### Stricter Enforcement

To block commits on failed quizzes, modify the hook prompt in `hooks/hooks.json` to return "block" instead of "proceed" when answers are incorrect. (Not recommended for most teams.)

## License

MIT
