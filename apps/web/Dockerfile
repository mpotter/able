FROM oven/bun:1.3 AS base

# Install dependencies
FROM base AS deps
WORKDIR /app

# Copy entire monorepo for workspace resolution
COPY package.json bun.lock ./
COPY apps/ ./apps/
COPY packages/ ./packages/

# Install dependencies with bun
RUN bun install --frozen-lockfile

# Build the application
FROM base AS builder
WORKDIR /app

COPY --from=deps /app ./

# Build Next.js app using bun
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app/apps/web
RUN bun run build

# Production image
FROM oven/bun:1.3-slim AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN groupadd --system --gid 1001 nodejs && \
    useradd --system --uid 1001 --gid nodejs nextjs

# Copy built assets
COPY --from=builder /app/apps/web/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./.next/static

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

WORKDIR /app/apps/web
CMD ["bun", "run", "server.js"]
