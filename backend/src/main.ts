import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import * as yaml from 'js-yaml';

async function bootstrap() {
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

  // Puerto fijo backend: 6002 (no modificar)
  const PORT = 6002;
  await app.listen(PORT);
}
bootstrap();
