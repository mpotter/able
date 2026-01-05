# Release Process

This document describes how releases work in the Able monorepo.

## Overview

We use [changesets](https://github.com/changesets/changesets) for versioning and release management. The process is automated via GitHub Actions.

## Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Development Flow                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. Create feature branch                                           │
│  2. Make changes                                                    │
│  3. Run `bun changeset` to describe changes                         │
│  4. Open PR → CI runs (lint, build, changeset check)                │
│  5. PR merged → auto-deploy to dev                                  │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                         Release Flow                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  6. Release workflow creates "chore: release" PR                    │
│  7. Review and merge release PR                                     │
│  8. GitHub Release created automatically                            │
│  9. Release triggers deploy to prod                                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Creating a Changeset

When your PR includes user-facing changes, create a changeset:

```bash
bun changeset
```

This will prompt you to:

1. Select affected packages
2. Choose version bump type (patch/minor/major)
3. Write a summary of changes

The changeset is saved as a markdown file in `.changeset/`.

### When to Create a Changeset

| Change Type         | Changeset Required |
| ------------------- | ------------------ |
| New features        | Yes (minor)        |
| Bug fixes           | Yes (patch)        |
| Breaking changes    | Yes (major)        |
| Documentation only  | No                 |
| CI/workflow changes | No                 |
| Internal refactors  | No                 |

For changes that don't need a changeset, add the `skip-changeset` label to your PR.

## GitHub Workflows

### CI Workflows (on PR)

| Workflow              | Trigger          | Purpose           |
| --------------------- | ---------------- | ----------------- |
| `ci-dotco.yml`        | App code changes | Lint and build    |
| `changeset-check.yml` | All PRs          | Require changeset |
| `terraform.yml`       | Infra changes    | Plan (dev only)   |

### Deploy Workflows (on merge)

| Workflow           | Trigger           | Purpose           |
| ------------------ | ----------------- | ----------------- |
| `deploy-dotco.yml` | Push to main      | Deploy to dev     |
| `deploy-dotco.yml` | Release published | Deploy to prod    |
| `terraform.yml`    | Push to main      | Apply terraform   |
| `release.yml`      | Push to main      | Create release PR |

## Release PR

When PRs with changesets are merged to main, the release workflow automatically:

1. Runs `changeset version` to:
   - Consume pending changesets
   - Bump package versions
   - Generate/update CHANGELOG.md
2. Creates or updates a "chore: release" PR
3. The PR accumulates changes from multiple merged PRs

### Merging the Release PR

When you merge the release PR:

1. The release workflow detects no pending changesets
2. Creates a GitHub Release with tag `{package-name}-v{version}` (e.g., `@able/dotco-v0.0.3`)
3. The release triggers a production deployment

## Version Strategy

We use [semver](https://semver.org/):

- **Patch** (0.0.x): Bug fixes, small improvements
- **Minor** (0.x.0): New features, non-breaking changes
- **Major** (x.0.0): Breaking changes

## Manual Operations

### Deploy to a specific environment

```bash
gh workflow run deploy-dotco.yml -f environment=dev
gh workflow run deploy-dotco.yml -f environment=prod
```

### Create a release manually

```bash
gh workflow run release.yml
```

## Troubleshooting

### Changeset check failing

1. Run `bun changeset` to create a changeset
2. Or add `skip-changeset` label if changes don't need a release

### Release PR not created

Check that:

1. There are pending changesets in `.changeset/`
2. The release workflow completed successfully
3. The GitHub App has permissions to create PRs

### Production deploy not triggered

Check that:

1. A GitHub Release was created
2. The release workflow completed the "Create GitHub Release" step
