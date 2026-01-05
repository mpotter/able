# Able

A full-stack application built with Next.js and deployed to AWS.

## Tech Stack

- **Runtime**: Bun
- **Frontend**: Next.js 15, React 19, Tailwind CSS 4
- **Database**: PostgreSQL with Drizzle ORM
- **AI**: Vercel AI SDK with Anthropic
- **Infrastructure**: AWS (ECS Fargate, Aurora Serverless, ALB, Route53)
- **IaC**: Terraform

## Getting Started

### Prerequisites

- [Bun](https://bun.sh)
- [Docker](https://docker.com) (for local database)

### Development

```bash
# Install dependencies
bun install

# Start development server
bun run dev
```

### Database

```bash
# Generate migrations after schema changes
bun run db:generate

# Run migrations
bun run db:migrate

# Open Drizzle Studio
bun run db:studio
```

## Project Structure

```
able/
├── apps/
│   └── web/           # Next.js application
├── packages/
│   ├── ai/            # AI SDK integration
│   ├── config/        # Shared configuration
│   ├── db/            # Database schema and client
│   └── ui/            # Shared UI components
├── infra/
│   └── terraform/     # AWS infrastructure
├── scripts/           # Setup and utility scripts
└── docs/              # Documentation
```

## Infrastructure

Infrastructure is managed with Terraform and deploys automatically via GitHub Actions.

- **Dev**: Deploys on push to `main`
- **Prod**: Deploys after dev succeeds

See [docs/SETUP.md](docs/SETUP.md) for initial setup instructions.

## Contributing

1. Create a feature branch from `main`
2. Make changes
3. Submit a pull request

Infrastructure changes trigger a Terraform plan on PR, and apply on merge.
