# NestJS + Prisma — despliegue (Railway, etc.)
FROM node:22-bookworm-slim AS deps
WORKDIR /app
RUN apt-get update -y && apt-get install -y openssl ca-certificates && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
COPY prisma ./prisma/
RUN npm ci

FROM deps AS build
COPY . .
RUN npx prisma generate
RUN npm run build

FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN apt-get update -y && apt-get install -y openssl ca-certificates && rm -rf /var/lib/apt/lists/*
COPY package.json package-lock.json ./
COPY prisma ./prisma/
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
COPY --from=build /app/generated ./generated
RUN mkdir -p uploads/comprobantes uploads/productos
EXPOSE 6002
# Railway inyecta PORT; local sigue pudiendo usar 6002 por defecto
CMD ["node", "dist/main.js"]
