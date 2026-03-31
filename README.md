# Delicias Bakery — Monorepo Next.js + NestJS

Aplicación web profesional para una panadería, migrada y consolidada en un monorepo con:
- Frontend: Next.js 15 (App Router, SSR/SSG), Tailwind CSS.
- Backend: NestJS 11 (JWT, Prisma), PostgreSQL (Supabase compatible) como base de datos.

## 🚀 Características

### Frontend (Next.js)
- Ruteo por archivos (App Router) y metadata por página.
- SSR/SSG donde aporta rendimiento (catálogo, páginas públicas).
- Autenticación con token JWT almacenado en cookie.
- Protección de rutas mediante `src/middleware.ts` (usuario y admin).
- Rewrites de `/api/*` y `/uploads/*` hacia el backend NestJS.
- Componentes de UI y diseño admin en `src/design/admin/`.

### Backend (NestJS)
- Módulos para autenticación, usuarios, productos, categorías, pedidos y facturación.
- Validación con `class-validator` y `ValidationPipe` global.
- JWT con expiración de 24h y estrategia Passport.
- Prisma ORM con `provider = "postgresql"` y modelos listos para producción.
- Servido de archivos estáticos en `/uploads` (imágenes de productos).
- Documentación de API con Swagger en `/api/docs` y YAML en `/api/docs-yaml`.

## 📁 Estructura del Proyecto

```
delicias/
├── backend/               # NestJS + Prisma (PostgreSQL)
│   ├── src/               # Módulos, controladores y servicios
│   ├── prisma/            # Esquema Prisma (PostgreSQL)
│   ├── uploads/           # Archivos subidos (servidos en /uploads)
│   └── scripts/seed-admin.js
├── frontend/              # Next.js (App Router)
│   ├── src/app/           # Rutas y layouts
│   ├── src/components/    # Componentes UI
│   ├── src/context/       # Contextos (Auth, Cart)
│   └── next.config.ts     # Rewrites hacia backend
└── package.json           # Scripts del monorepo
```

## 📋 Requisitos Previos

- Node.js 18+ (recomendado 20+).
- Postgres (recomendado Supabase) en local o en servicio gestionado.
- npm (o yarn/pnpm).
- Flutter 3.9+ (para ejecutar `app_delicias`).
- Git (para clonar el repo en la otra PC).

## ⚙️ Configuración

1) Instalar dependencias del monorepo:

```bash
npm run install-all
```

2) Backend — Variables de entorno (`backend/.env`):

```env
JWT_SECRET="tu_jwt_secret_seguro"
DATABASE_URL="postgresql://usuario:password@localhost:5432/delicias"
# Supabase en Railway/hosting IPv4: usa la URL "Transaction pool" (6543), no db.*.supabase.co:5432
# Credenciales para seeding (opcional)
ADMIN_EMAIL="admin@delicias.com"
ADMIN_PASSWORD="Admin123456!"
# Opcional (si usas el endpoint de Decolecta / facturación)
DECOLECTA_BASE_URL="https://api.decolecta.com/v1"
DECOLECTA_TOKEN="TU_TOKEN_AQUI"
# Opcional (límite de subida de archivos)
MAX_FILE_SIZE=5242880
```

3) Generar Prisma (si es primera vez):

```bash
cd backend
npx prisma generate
```

4) Crear tablas en la base de datos:

Si usas Supabase:

```txt
backend/prisma/supabase-init.sql
```

Ejecuta ese SQL en Supabase (SQL Editor → New query → Run).

5) Sembrar admin por defecto (opcional):

```bash
cd backend
npm run seed:admin
```

## ▶️ Ejecución en Desarrollo

Desde la raíz del monorepo:

```bash
npm run dev
```

- Frontend (Next): http://localhost:6001
- Admin (Next): http://localhost:6003
- Backend (Nest): http://localhost:6002

El frontend reescribe `/api/*` y `/uploads/*` hacia el backend, por lo que las llamadas `axios` a `/api/...` funcionan sin configurar dominios manualmente.

Docs del backend:
- http://localhost:6002/api/docs
- http://localhost:6002/api/docs-yaml

## ☁️ Railway: conectar backend, frontend y admin

Cada servicio es un contenedor distinto. La tienda y el panel **no** adivinan la URL del API: hay que pasarla con la misma variable en los **dos** Next.js.

1. **Backend** (Nest): en Railway abre ese servicio → **Settings → Networking** y copia la URL pública **HTTPS** (o genera dominio). Debe verse como `https://algo.up.railway.app` — **sin** `/` al final y **sin** `/api`.

2. **Frontend** (tienda): servicio del proyecto → **Variables** → crea o edita:
   - `BACKEND_URL` = la URL del paso 1 (exactamente la misma cadena).

3. **Admin** (panel): **Variables** → otra vez:
   - `BACKEND_URL` = la **misma** URL del backend.

4. Guarda y haz **Redeploy** del frontend y del admin (el Dockerfile usa `BACKEND_URL` en el build; si no estaba definida antes, el primer deploy pudo quedar con `localhost`).

5. **App Flutter** (`app_delicias/.env`): `API_BASE_URL` = esa misma URL base del backend (HTTPS, sin `/api`).

Con eso, los rewrites de `next.config.ts` envían `/api/*` y `/uploads/*` al Nest desplegado. Si algo falla, abre la URL del backend en el navegador: debería responder JSON en `/` y Swagger en `/api/docs`.

## 📱 App Móvil (Flutter)

En la otra PC (o en la misma red), la app móvil se levanta aparte del monorepo web.

Requisitos:
- Flutter 3.9+.
- Tener un emulador o un dispositivo físico, y que `API_HOST:API_PORT` sea accesible desde ese equipo/dispositivo.

1) Ajusta `app_delicias/.env`:

**Local** (Nest en tu PC, mismo WiFi):

```env
API_HOST=IP_DE_LA_PC_QUE_CORRE_EL_BACKEND
API_PORT=6002
```

**Producción** (backend en Railway u otro HTTPS): comenta `API_HOST`/`API_PORT` y usa la URL pública del API (sin `/api` al final):

```env
API_BASE_URL=https://tu-servicio-backend.up.railway.app
```

Copia `app_delicias/.env.example` como referencia.

2) Ejecuta:

```bash
cd app_delicias
flutter pub get
flutter run
```

## 🧪 Pruebas

- Backend (Nest):
```bash
cd backend
npm run test
npm run test:e2e
```

- Frontend (Next): pendiente de integrar pruebas (p. ej. Vitest/Playwright).

## 🔐 Usuarios por Defecto

Si ejecutaste el seed:
- Admin: `admin@delicias.com` / `Admin123456!` (puedes cambiarlo en `backend/.env`).

## 🧰 Tecnologías

### Frontend
- Next.js 15, React 19, Tailwind CSS 4, Framer Motion, Lucide React, Swiper.

### Backend
- NestJS 11, Prisma, JWT, Bcrypt, Swagger.

## 📖 Notas de Migración

- Se eliminó la app independiente de React (CRA/Vite/React Router DOM). El frontend ahora es 100% Next.js con App Router.
- Las rutas protegidas se manejan vía `middleware.ts` y verificación en backend.
- Las llamadas a API se realizan contra `/api/*`, y son atendidas por NestJS mediante rewrites definidos en `next.config.ts`.

## 📄 Licencia

MIT.

## 📞 Soporte

Para soporte o preguntas, contacta a: soporte@delicias.com

---

¡Gracias por usar Delicias Bakery! 🥖🧁