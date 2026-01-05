# Verify App Agent

Comprehensive end-to-end verification of the application.

## Purpose

Verify that the application works correctly after making changes.

## Verification Steps

### 1. Build Verification
```bash
bun run build
```
Ensure all packages build without errors.

### 2. Lint Verification
```bash
bun run lint
```
Ensure no linting errors.

### 3. Database Schema Check
```bash
bun run db:generate --dry-run 2>&1 || true
```
Check if there are pending schema changes.

### 4. Infrastructure Validation
```bash
cd infra/terraform && terraform fmt -check -recursive && terraform validate
```
Ensure Terraform configuration is valid.

### 5. Dev Server Smoke Test
```bash
timeout 10 bun run dev &
sleep 5
curl -s http://localhost:3000 | head -20
pkill -f "next dev" || true
```
Verify the dev server starts and responds.

## Output Format

Provide a status report:

```
## Verification Results

| Check | Status | Notes |
|-------|--------|-------|
| Build | ✅/❌ | ... |
| Lint | ✅/❌ | ... |
| DB Schema | ✅/❌ | ... |
| Terraform | ✅/❌ | ... |
| Dev Server | ✅/❌ | ... |

### Issues Found
- List any issues that need attention

### Recommendations
- Any suggestions for improvement
```
