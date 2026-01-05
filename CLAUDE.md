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

### Release Process

This repo uses [changesets](https://github.com/changesets/changesets) for versioning and releases.

**For contributors:**
1. Make your changes on a feature branch
2. Run `bun run changeset` to create a changeset describing your changes
3. Select the packages affected and the semver bump type (patch/minor/major)
4. Commit the generated `.changeset/*.md` file with your PR

**Automated flow:**
1. PRs merged to `main` → auto-deploy to **dev**
2. When PRs with changesets are merged, a "chore: release" PR is created/updated
3. Merging the release PR → creates a GitHub release → auto-deploy to **prod**

**When to add a changeset:**
- New features, bug fixes, or breaking changes that affect users
- Skip for: CI changes, docs, internal refactors with no user impact
