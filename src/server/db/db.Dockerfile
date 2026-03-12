FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y curl tzdata ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the precompiled surreal binary from the official image
COPY --from=surrealdb/surrealdb:v3 /surreal /bin/surreal

ENV LANG=C.UTF-8
ENV TZ=UTC

COPY entrypoint.sh /entrypoint.sh
COPY seed.surql /seed.surql
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
