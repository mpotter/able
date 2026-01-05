# Able

Monorepo for Able. See [content/PUBLIC.md](content/PUBLIC.md) for company info.

## Structure

```
able/
├── apps/           # Applications
├── packages/       # Shared packages
├── infra/          # Infrastructure (Terraform)
├── scripts/        # Setup and utility scripts
├── docs/           # Documentation
└── content/        # Company content
```

## Setup

**Local development**: `bun install` then copy `.env.example` to `.env.local` with your keys.

**Infrastructure**: Run `./scripts/infra-setup.sh` to validate AWS/GitHub/Terraform. See [docs/INFRA.md](docs/INFRA.md).

## Commands

```bash
bun run dev              # Start development
bun install              # Install dependencies
bun run build            # Build all packages
bun run lint             # Lint all packages

# Database
bun run db:generate      # Generate Drizzle migrations
bun run db:migrate       # Run migrations
bun run db:studio        # Open Drizzle Studio

# Releases
bun run changeset        # Create a changeset for your PR

# Infrastructure (local)
AWS_PROFILE=able terraform plan
AWS_PROFILE=able terraform apply
```

## Development Guidelines

- Use TypeScript for all code
- Follow existing patterns in the codebase
- Use Tailwind CSS for styling

### Database Changes

- Generate migrations with `bun run db:generate` after schema changes
- Test migrations locally before pushing
- Never modify existing migrations

### Git Workflow

- Create feature branches from `main`
- Use descriptive commit messages
- Infrastructure changes auto-deploy on merge to `main`

### Claude Workflow

When implementing features or fixes:

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes and commit
3. Create a changeset file in `.changeset/` (patch/minor/major based on change type)
4. Push and create PR: `git push -u origin HEAD && gh pr create`
5. User approves and merges → deploys to dev
6. Release PR auto-created → user merges → deploys to prod

Skip changeset for: CI changes, docs-only, internal refactors (add `skip-changeset` label)

### Release Process

See [docs/RELEASES.md](docs/RELEASES.md) for full details.

**Quick start:** Run `bun changeset` before opening a PR with user-facing changes. Skip for CI/docs/refactors (use `skip-changeset` label).
