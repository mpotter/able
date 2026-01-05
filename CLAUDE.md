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
