# Next.js (tienda) — despliegue
FROM node:22-bookworm-slim AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM deps AS build
WORKDIR /app
COPY . .
# URL del API Nest (mismo host en Railway o nombre de servicio en Docker Compose)
ARG BACKEND_URL=http://localhost:6002
ENV BACKEND_URL=$BACKEND_URL
RUN npm run build

FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
EXPOSE 3000
CMD ["sh", "-c", "exec npx next start -H 0.0.0.0 -p ${PORT:-3000}"]
