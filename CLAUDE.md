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
└── content/           # Static content
```

## Tech Stack

- **Runtime**: Bun
- **Frontend**: Next.js 15, React 19, Tailwind CSS 4
- **Database**: PostgreSQL with Drizzle ORM
- **AI**: AI SDK with Anthropic provider
- **Infrastructure**: AWS (ECS Fargate, Aurora PostgreSQL, ALB, Route53)
- **IaC**: Terraform

## Commands

### Development
```bash
bun run dev              # Start Next.js dev server
bun install              # Install dependencies
```

### Database
```bash
bun run db:generate      # Generate Drizzle migrations
bun run db:migrate       # Run migrations
bun run db:studio        # Open Drizzle Studio
```

### Build & Lint
```bash
bun run build            # Build all packages
bun run lint             # Lint all packages
```

### Infrastructure
```bash
# Use AWS_PROFILE=able for local terraform commands
AWS_PROFILE=able terraform init
AWS_PROFILE=able terraform plan -var-file=environments/shared.tfvars -var-file=environments/dev.tfvars
AWS_PROFILE=able terraform apply -var-file=environments/shared.tfvars -var-file=environments/dev.tfvars
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

## Common Mistakes to Avoid

- Don't import from `@able/db` directly; use `@able/db/schema` for schema types
- Don't hardcode environment variables; use `.env.local` for local dev
- Don't skip Drizzle migration generation after schema changes
- Don't run `terraform apply` without reviewing the plan first
