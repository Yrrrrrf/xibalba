# // TODO: Update Dockerfiles to use oven/bun
FROM denoland/deno:2.6.4

WORKDIR /app

COPY deno.json .
COPY sdk/ sdk/
COPY apps/ apps/

RUN deno install --allow-scripts

EXPOSE 5173

# todo: Change this to use vite-plus
# todo: vp dev --host!
CMD ["deno", "task", "dev", "--host"]
