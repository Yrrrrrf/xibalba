FROM oven/bun:latest

WORKDIR /app

# Copy the entire client workspace
COPY . .

# Install workspace dependencies
RUN bun install

# The default command (will be overridden by docker-compose)
CMD ["bun", "run", "dev"]