import { join } from 'path';
import { config as loadDotenv } from 'dotenv';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

// Carga backend/.env antes de Nest (local). En Railway las variables ya vienen en process.env.
loadDotenv({ path: join(__dirname, '..', '.env') });

// Prisma pide DIRECT_URL en el schema; en Railway suele bastar DATABASE_URL (misma cadena).
const _db = process.env.DATABASE_URL?.trim();
if (_db && !process.env.DIRECT_URL?.trim()) {
  process.env.DIRECT_URL = _db;
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
      '  (DIRECT_URL no hace falta si ya tienes DATABASE_URL; se reutiliza automáticamente.)\n',
  );
  process.exit(1);
}

async function bootstrap() {
  assertRequiredEnvForStartup();
  let app;
  try {
    app = await NestFactory.create(AppModule);
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error(
      '[FATAL] Nest no pudo arrancar (revisa DATABASE_URL / red a Postgres, o errores de módulos):',
      e,
    );
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
