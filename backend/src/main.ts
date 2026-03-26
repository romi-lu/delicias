import { join } from 'path';
import { config as loadDotenv } from 'dotenv';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

// Carga backend/.env antes de Nest (local). En Railway las variables ya vienen en process.env.
loadDotenv({ path: join(__dirname, '..', '.env') });

function assertRequiredEnvForStartup(): void {
  const missing: string[] = [];
  if (!process.env.JWT_SECRET?.trim()) missing.push('JWT_SECRET');
  if (!process.env.DATABASE_URL?.trim()) missing.push('DATABASE_URL');
  if (!process.env.DIRECT_URL?.trim()) missing.push('DIRECT_URL');
  if (missing.length === 0) return;

  // eslint-disable-next-line no-console
  console.error(`
[FATAL] Faltan variables de entorno: ${missing.join(', ')}

En Railway → servicio del BACKEND → Variables, define:
  · JWT_SECRET     → cadena aleatoria larga (ej. openssl rand -base64 48)
  · DATABASE_URL   → URL de Postgres (si añades plugin Postgres, usa "Reference" a DATABASE_URL)
  · DIRECT_URL     → igual que DATABASE_URL salvo que Prisma/Supabase indique otra (misma URL suele valer)

Luego Redeploy. Los "Build logs" pueden estar OK; el fallo del healthcheck sale en **Deploy logs** si el proceso muere al arrancar.
`);
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
