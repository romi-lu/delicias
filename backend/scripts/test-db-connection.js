/**
 * Prueba de conexión a Supabase.
 * Ejecutar: node scripts/test-db-connection.js
 * Asegúrate de tener la contraseña real en .env (DATABASE_URL).
 */
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });
const { execSync } = require('child_process');

const direct = process.env.DATABASE_URL || '';
const hasPlaceholder = direct.includes('YOUR-DATABASE-PASSWORD') || direct.includes('[YOUR-DATABASE-PASSWORD]');

if (hasPlaceholder) {
  console.log('Reemplaza [YOUR-DATABASE-PASSWORD] en backend/.env por tu contraseña de Supabase.');
  process.exit(1);
}

console.log('Probando conexión...');
try {
  execSync('npx prisma db execute --stdin --schema prisma/schema.prisma', {
    input: 'SELECT 1 as ok;',
    cwd: require('path').join(__dirname, '..'),
    stdio: ['pipe', 'inherit', 'inherit'],
  });
  console.log('Conexión correcta.');
} catch (e) {
  console.log('No se pudo conectar. Usa SQL Editor en Supabase para crear las tablas (prisma/supabase-init.sql).');
  process.exit(1);
}
