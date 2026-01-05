# Code Simplifier Agent

Review and simplify the code that was just written.

## Purpose

After implementing a feature or fix, use this agent to:
- Remove unnecessary complexity
- Consolidate duplicate logic
- Improve readability
- Reduce lines of code without sacrificing clarity

## Instructions

1. Review the files that were recently modified
2. Look for opportunities to simplify:
   - Combine similar functions or components
   - Remove dead code or unused imports
   - Simplify conditional logic
   - Use more concise syntax where appropriate
   - Extract magic numbers/strings to constants only if used multiple times

3. Do NOT:
   - Add new features
   - Change behavior
   - Add unnecessary abstractions
   - Over-engineer simple solutions

4. Make targeted edits to simplify the code

5. Run verification after changes:
   ```bash
   bun run build
   bun run lint
   ```

## Output

Report what was simplified and why.
