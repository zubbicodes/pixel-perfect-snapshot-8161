FROM node:22-slim AS base
WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package.json bun.lock bunfig.toml ./
RUN npm install -g bun && bun install --frozen-lockfile

# Builder
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Build the application
RUN npm install -g bun && bun run build

# Runner
FROM base AS runner
WORKDIR /app

# Install Nginx and curl
RUN apt-get update && apt-get install -y nginx curl && rm -rf /var/lib/apt/lists/*

# Copy built application
COPY --from=builder /app/.output /app/.output

# Copy Nginx config
COPY nginx.conf /etc/nginx/sites-available/default
# Copy startup script
COPY start.sh /app/start.sh

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 80

CMD ["/app/start.sh"]
