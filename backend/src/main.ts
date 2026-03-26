import { join } from 'path';
import { config as loadDotenv } from 'dotenv';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

// Carga backend/.env antes de Nest (local). En Railway las variables ya vienen en process.env.
loadDotenv({ path: join(__dirname, '..', '.env') });

function assertJwtSecretForStartup(): void {
  if (process.env.JWT_SECRET?.trim()) return;
  // eslint-disable-next-line no-console
  console.error(`
[FATAL] JWT_SECRET no está definido en este proceso.

Railway (servicio del BACKEND, no el de frontend):
  1. Variables → "+ New Variable"
  2. Name:  JWT_SECRET   (exactamente así, en mayúsculas)
  3. Value: una cadena larga aleatoria (ej. openssl rand -base64 48)
  4. Guardar → Deploy / Redeploy

Comprueba que la variable no tenga espacios en el nombre ni valor vacío.
`);
  process.exit(1);
}

async function bootstrap() {
  assertJwtSecretForStartup();
  const app = await NestFactory.create(AppModule);
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
}
bootstrap();
