# Able

We accelerate AI automation.

## Local Development

```bash
# Install dependencies
bun install

# Copy environment template
cp apps/dotco/.env.example apps/dotco/.env.local
# Edit .env.local with your ANTHROPIC_API_KEY and DATABASE_URL

# Start development
bun run dev
```

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

## Documentation

- [CLAUDE.md](CLAUDE.md) - Development guidelines
- [docs/INFRA.md](docs/INFRA.md) - Infrastructure setup (AWS, Terraform, CI)
