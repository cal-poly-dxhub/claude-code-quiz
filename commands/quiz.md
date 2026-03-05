---
description: Quiz yourself on recent code changes to verify your understanding
---

When the user invokes this command:

1. **Identify code to quiz on:**
   - First check for uncommitted changes using `git diff` and `git diff --cached`
   - If no uncommitted changes exist, analyze the last commit using `git show HEAD`
   - If not in a git repo, inform the user and exit

2. **Analyze the changes:**
   - Review the code modifications carefully
   - Identify key concepts, patterns, and logic in the changes
   - Note any potential edge cases or important details

3. **Generate 3-5 quiz questions:**
   - Create questions that test understanding, not just recall
   - Include questions about:
     - What the code does and why
     - How specific functions or logic blocks work
     - What would happen if certain inputs were provided
     - Why certain implementation choices were made
   - Vary difficulty from basic to moderate
   - Each question should have 4 multiple choice options (A, B, C, D)

4. **Present ALL questions at once:**
   - Display all questions in a single numbered list with their multiple choice options
   - Then use a SINGLE AskUserQuestion call asking the user to provide all their answers
   - Format the prompt like: "Enter your answers (e.g. 1:A 2:B 3:C 4:D 5:A)"
   - Do NOT ask questions one at a time

5. **Evaluate all answers together:**
   - After receiving all answers, go through each one
   - For each question, state whether the answer was correct or incorrect
   - For incorrect answers, provide the correct answer with a brief explanation
   - Reference specific lines of code when explaining

6. **Summarize results:**
   - Show the user's score (e.g., "3/5 correct")
   - Highlight any areas where understanding could be improved
   - Encourage the user if they did well
