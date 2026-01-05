# Able

A full-stack application built with Next.js and deployed to AWS.

## Project Structure

```
able/
├── apps/
│   └── web/           # Next.js 15 frontend (@able/web)
├── packages/
│   ├── ai/            # AI SDK integration (@able/ai)
│   ├── config/        # Shared configuration (@able/config)
│   ├── db/            # Drizzle ORM + Postgres (@able/db)
│   └── ui/            # Shared UI components (@able/ui)
├── infra/
│   └── terraform/     # AWS infrastructure (ECS, Aurora, ALB)
├── scripts/           # Setup and utility scripts
├── docs/              # Documentation
└── content/           # Static content
```

## Setup

Run `./scripts/setup.sh` to validate and configure the environment. See [docs/SETUP.md](docs/SETUP.md) for details.

**Note**: Any new setup requirements should be added to `scripts/setup.sh` to keep configuration automated and documented.

## Commands

```bash
# Development
bun run dev              # Start Next.js dev server
bun install              # Install dependencies

# Database
bun run db:generate      # Generate Drizzle migrations
bun run db:migrate       # Run migrations
bun run db:studio        # Open Drizzle Studio

# Build
bun run build            # Build all packages
bun run lint             # Lint all packages

# Infrastructure (local)
AWS_PROFILE=able terraform plan
AWS_PROFILE=able terraform apply
```

## Development Guidelines

### Code Style
- Use TypeScript for all code
- Follow existing patterns in the codebase
- Keep components small and focused
- Use Tailwind CSS for styling

### Database Changes
- Always generate migrations with `bun run db:generate` after schema changes
- Test migrations locally before pushing
- Never modify existing migrations

### Git Workflow
- Create feature branches from `main`
- Use descriptive commit messages
- Infrastructure changes auto-deploy on merge to `main`

## Common Mistakes

- Don't import from `@able/db` directly; use `@able/db/schema` for schema types
- Don't hardcode environment variables; use `.env.local` for local dev
- Don't skip Drizzle migration generation after schema changes
- Don't run `terraform apply` without reviewing the plan first
