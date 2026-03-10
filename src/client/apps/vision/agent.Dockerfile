FROM denoland/deno:2.6.4

WORKDIR /app

# 1. Copy the Workspace Configuration first (caching)
COPY deno.json .

# 2. Copy the Shared Packages
COPY sdk/ sdk/

# 3. Copy the Apps
COPY apps/ apps/

# 4. Install Dependencies (Deno 2.x reads package.json/deno.json and creates node_modules)
# We run this at the root so the workspace links are created
RUN deno install --allow-scripts

# 5. Expose the Vite port (Standard for both apps)
EXPOSE 5173

# 6. Default command (can be overridden by docker-compose)
CMD ["deno", "task", "dev", "--host"]