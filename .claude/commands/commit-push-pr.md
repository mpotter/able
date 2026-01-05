# Commit, Push, and Create PR

Commit all changes, push to remote, and create a pull request.

## Context

```bash
# Current branch and status
git branch --show-current
git status --short
git diff --stat
```

## Instructions

1. Review the staged and unstaged changes shown above
2. Stage all relevant changes with `git add`
3. Create a commit with a descriptive message that explains the "why" not just the "what"
4. Push to the remote (create upstream branch if needed with `-u`)
5. Create a pull request using `gh pr create` with:
   - A clear, descriptive title
   - A summary of changes in the body
   - Link any related issues if mentioned in commits

Use this format for the PR:
```
gh pr create --title "Title here" --body "$(cat <<'EOF'
## Summary
- Brief description of changes

## Test plan
- [ ] How to verify this works

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Return the PR URL when complete.
