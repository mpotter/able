# Able

Monorepo for Able - we accelerate AI automation.

See [content/PUBLIC.md](content/PUBLIC.md) for more about what we do.

## Getting Started

```bash
# Install dependencies
bun install

# Run setup to validate environment
./scripts/setup.sh

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

- [docs/SETUP.md](docs/SETUP.md) - Environment setup
- [CLAUDE.md](CLAUDE.md) - Development guidelines
