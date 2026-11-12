# syntax=docker/dockerfile:1
# UAT host for the game web builds. The build context is the staging folder made by scripts/deploy.sh:
#   web/<game>/...      the Flutter web builds (all games; baked into the image)
#   serve-static.cjs    the static server
# Build args come from config.json via deploy.sh.
FROM node:22-bookworm-slim
ENV NODE_ENV=production SERVE_HOST=0.0.0.0 SERVE_PATH=/app/web
WORKDIR /app
COPY serve-static.cjs ./serve-static.cjs
COPY web ./web
ARG SERVE_PORT=7000
ARG SERVE_BASE=/appgames
ENV SERVE_PORT=${SERVE_PORT} SERVE_BASE=${SERVE_BASE}
USER node
EXPOSE ${SERVE_PORT}
CMD ["node", "serve-static.cjs"]
