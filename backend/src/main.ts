import { join } from 'path';
import { config as loadDotenv } from 'dotenv';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

// Carga backend/.env antes de Nest (local). En Railway las variables ya vienen en process.env.
loadDotenv({ path: join(__dirname, '..', '.env') });

function assertSupabaseNotDirectInProduction(): void {
  if (process.env.NODE_ENV !== 'production') return;
  const raw = process.env.DATABASE_URL?.trim();
  if (!raw) return;
  try {
    const u = new URL(raw.replace(/^postgresql:/i, 'http:'));
    const h = u.hostname;
    const port = u.port || '5432';
    if (h.startsWith('db.') && h.endsWith('.supabase.co') && port === '5432') {
      // eslint-disable-next-line no-console
      console.error(`
[FATAL] DATABASE_URL apunta al host directo de Supabase (${h}:5432).
Desde Railway (y muchos hosts IPv4) esa dirección no responde → Prisma P1001.

En Supabase: Settings → Database → Connection string → modo "Transaction" (pooler, puerto 6543).
Copia esa URL completa y sustituye DATABASE_URL en Railway. Redeploy.

El host del pooler suele contener "pooler" y NO empezar por "db.".
`);
      process.exit(1);
    }
  } catch {
    /* URL rara; deja que Prisma falle con su mensaje */
  }
}

function assertRequiredEnvForStartup(): void {
  const missing: string[] = [];
  if (!process.env.JWT_SECRET?.trim()) missing.push('JWT_SECRET');
  if (!process.env.DATABASE_URL?.trim()) missing.push('DATABASE_URL');
  if (missing.length === 0) return;

  // eslint-disable-next-line no-console
  console.error(
    `[FATAL] Faltan variables de entorno: ${missing.join(', ')}\n\n` +
      'En Railway:\n' +
      '  1) Abre el PROYECTO → el SERVICIO que despliega la API (no Postgres solo).\n' +
      '  2) Pestaña "Variables" → "+ New Variable" (o "Raw Editor").\n' +
      '  3) Añade exactamente:\n' +
      '       JWT_SECRET = (texto largo aleatorio; en PowerShell: [Convert]::ToBase64String((1..32|%{Get-Random -Max 256})))\n' +
      '       DATABASE_URL = URL de Postgres\n' +
      '     Si tienes Postgres en Railway: en el servicio Postgres copia "DATABASE_URL" y pégala en el servicio del backend,\n' +
      '     o usa "Variable Reference" ${{Postgres.DATABASE_URL}} según te muestre el asistente.\n' +
      '  4) Guarda y pulsa Redeploy en el servicio del backend.\n' +
      '  Supabase en Railway: usa URL del pool Transaction (6543), no db.*.supabase.co:5432.\n',
  );
  process.exit(1);
}

async function bootstrap() {
  assertRequiredEnvForStartup();
  assertSupabaseNotDirectInProduction();
  let app;
  try {
    app = await NestFactory.create(AppModule);
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error('[FATAL] Nest no pudo arrancar:', e);
    const msg = e instanceof Error ? e.message : String(e);
    if (msg.includes('P1001') || msg.includes("Can't reach database")) {
      // eslint-disable-next-line no-console
      console.error(`
→ Prisma no puede conectar al Postgres (P1001).

Si usas Supabase y despliegas en Railway / Fly / etc. (red IPv4):
  La URL directa db.PROYECTO.supabase.co:5432 a menudo es solo IPv6 y desde ahí falla.
  Solución: Supabase Dashboard → Settings → Database → sección "Connection string"
  → pestaña "Transaction pool" o "Session pool" (puerto 6543, host ...pooler.supabase.com).
  Pega esa URL como DATABASE_URL en Railway (suele incluir ssl y parámetros del pooler).

Comprueba también: proyecto Supabase no pausado, contraseña correcta, ?sslmode=require en la URL.
`);
    }
    process.exit(1);
  }
  app.enableCors({
    origin: '*',
    credentials: true,
  });

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Prefijo global para mantener rutas /api/*
  app.setGlobalPrefix('api');

  // Swagger (OpenAPI) configuration
  const config = new DocumentBuilder()
    .setTitle('Delicias API')
    .setDescription('API de Delicias - Autenticación, Usuarios, Productos y Categorías')
    .setVersion('1.0.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  // Exponer también el contrato en YAML
  const yamlDoc = yaml.dump(document);
  app.use('/api/docs-yaml', (req, res) => {
    res.type('text/yaml').send(yamlDoc);
  });

  // Respuesta en la ruta raíz (evita 404 al abrir http://localhost:6002)
  const httpAdapter = app.getHttpAdapter();
  if (httpAdapter.get) {
    httpAdapter.get('/', (req: any, res: any) => {
      res.json({
        message: 'Delicias API',
        api: '/api',
        docs: '/api/docs',
        health: '/api/health',
      });
    });
  }

  const PORT = Number(process.env.PORT) || 6002;
  await app.listen(PORT, '0.0.0.0');
  // eslint-disable-next-line no-console
  console.log(`Listening on 0.0.0.0:${PORT} (healthcheck suele usar GET /)`);
}
bootstrap().catch((e) => {
  // eslint-disable-next-line no-console
  console.error('[FATAL] bootstrap:', e);
  process.exit(1);
});
