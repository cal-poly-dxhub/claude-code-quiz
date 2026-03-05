# Claude Code Quiz

A plugin for [Claude Code](https://github.com/anthropics/claude-code) that quizzes developers on their code changes before committing or pushing.

## Why?

Designed to combat "vibe coding" - when developers push code without fully understanding what it does. This plugin helps ensure you actually comprehend the changes you're committing.

## Features

### 1. Voluntary Quiz (`/quiz`)

Test yourself on recent code changes at any time:

```
/code-quiz:quiz
```

Analyzes your uncommitted changes (or last commit if working tree is clean) and generates 3-5 questions to test your understanding.

### 2. Pre-Commit/Push Hook

Automatically prompts you with 2-3 questions before any `git commit` or `git push` operation.

**Soft enforcement** - you'll see the quiz and get feedback, but the operation proceeds regardless of your answers. The goal is awareness, not blocking.

## Installation

### Option 1: Install from GitHub (recommended)

1. In Claude Code, add the marketplace:

```
/plugin marketplace add cal-poly-dxhub/claude-code-quiz
```

2. Open the plugin manager and navigate to the marketplace:

```
/plugin
```

3. Go to the **Marketplaces** tab, select **cal-poly-dxhub-claude-code-quiz**, then install the **code-quiz** plugin.

4. **Restart Claude Code** for the hooks to take effect.

### Option 2: Auto-configure for your team

Add to your project's `.claude/settings.json` so team members are prompted to install automatically:

```json
{
  "extraKnownMarketplaces": {
    "cal-poly-dxhub-claude-code-quiz": {
      "source": {
        "source": "github",
        "repo": "cal-poly-dxhub/claude-code-quiz"
      }
    }
  },
  "enabledPlugins": {
    "code-quiz@cal-poly-dxhub-claude-code-quiz": true
  }
}
```

### Option 3: Test locally during development

```bash
git clone https://github.com/cal-poly-dxhub/claude-code-quiz.git
claude --plugin-dir ./claude-code-quiz
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
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace catalog
├── commands/
│   └── quiz.md              # Voluntary /code-quiz:quiz command
├── hooks/
│   ├── hooks.json           # PreToolUse hook configuration
│   └── scripts/
│       └── check-git-op.sh  # Script to detect git commit/push
├── skills/
│   └── quiz/
│       └── SKILL.md         # Agent skill for code quizzing
└── README.md
```

## Customization

### Adjust Question Count

Edit `hooks/scripts/check-git-op.sh` and change "2-3 questions" in the `permissionDecisionReason` to your preferred number.

### Stricter Enforcement

To block commits on failed quizzes, remove the retry logic in `hooks/scripts/check-git-op.sh` so the hook always denies git operations when quiz answers are incorrect. (Not recommended for most teams.)

## Disclaimers 

Customers are responsible for making their own independent assessment of the information in this document. 

This document: 

(a) is for informational purposes only, 

(b) references AWS product offerings and practices, which are subject to change without notice, 

(c) does not create any commitments or assurances from AWS and its affiliates, suppliers or licensors. AWS products or services are provided "as is" without warranties, representations, or conditions of any kind, whether express or implied. The responsibilities and liabilities of AWS to its customers are controlled by AWS agreements, and this document is not part of, nor does it modify, any agreement between AWS and its customers, and 

(d) is not to be considered a recommendation or viewpoint of AWS. 

Additionally, you are solely responsible for testing, security and optimizing all code and assets on GitHub repo, and all such code and assets should be considered: 

(a) as-is and without warranties or representations of any kind, 

(b) not suitable for production environments, or on production or other critical data, and 

(c) to include shortcuts in order to support rapid prototyping such as, but not limited to, relaxed authentication and authorization and a lack of strict adherence to security best practices. 

All work produced is open source. More information can be found in the GitHub repo.

## License

MIT
