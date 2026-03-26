import { ConfigService } from '@nestjs/config';

/**
 * JWT_SECRET debe existir en el entorno del contenedor (Railway → Variables del servicio).
 * Combinamos ConfigService y process.env por si alguna capa no expone la variable.
 */
export function resolveJwtSecret(config: ConfigService): string {
  const fromEnv = process.env.JWT_SECRET;
  const fromConfig = config.get<string>('JWT_SECRET');
  const raw = fromEnv ?? fromConfig;
  const secret = typeof raw === 'string' ? raw.trim() : '';
  if (!secret) {
    throw new Error(
      'JWT_SECRET no está definido o está vacío. ' +
        'En Railway: entra al servicio que ejecuta ESTE backend → Variables → añade JWT_SECRET ' +
        '(nombre exacto, mayúsculas) con un valor aleatorio largo (32+ caracteres). ' +
        'Guarda y haz Redeploy. Si la variable está en otro servicio o proyecto, no llega al contenedor.',
    );
  }
  return secret;
}
