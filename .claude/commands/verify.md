# Verify

Run all verification checks to ensure the codebase is in good shape.

## Instructions

Run the following checks in order and report results:

1. **TypeScript Check**
   ```bash
   bun run --filter=* build 2>&1 | head -50
   ```

2. **Lint Check**
   ```bash
   bun run lint
   ```

3. **Terraform Validation** (if terraform files changed)
   ```bash
   cd infra/terraform && terraform fmt -check -recursive && terraform validate
   ```

## Output Format

Report a summary like:

✅ TypeScript: No errors
✅ Lint: Passed
✅ Terraform: Valid

Or if there are issues:

❌ TypeScript: 3 errors found
  - src/app/page.tsx:15 - Type error...

Fix any issues found before completing.
