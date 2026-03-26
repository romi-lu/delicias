# API NestJS — contexto = raíz del monorepo (Railway sin "Root Directory").
# Si en Railway pones Root Directory = backend, usa backend/Dockerfile en su lugar.
FROM node:22-bookworm-slim AS deps
WORKDIR /app
RUN apt-get update -y && apt-get install -y openssl ca-certificates && rm -rf /var/lib/apt/lists/*
COPY backend/package.json backend/package-lock.json ./
COPY backend/prisma ./prisma/
RUN npm ci

FROM deps AS build
COPY backend/ .
RUN npx prisma generate
RUN npm run build

FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN apt-get update -y && apt-get install -y openssl ca-certificates && rm -rf /var/lib/apt/lists/*
COPY backend/package.json backend/package-lock.json ./
COPY backend/prisma ./prisma/
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
COPY --from=build /app/generated ./generated
RUN mkdir -p uploads/comprobantes uploads/productos
EXPOSE 6002
CMD ["node", "dist/main.js"]
