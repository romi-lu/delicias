// Script para crear un usuario de prueba para la app móvil
const { PrismaClient } = require('../generated/prisma');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

function loadDotEnv(filePath) {
  try {
    if (!fs.existsSync(filePath)) return;
    const raw = fs.readFileSync(filePath, 'utf-8');
    for (const line of raw.split(/\r?\n/)) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const eq = trimmed.indexOf('=');
      if (eq === -1) continue;
      const key = trimmed.slice(0, eq).trim();
      let value = trimmed.slice(eq + 1).trim();
      if (
        (value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))
      ) {
        value = value.slice(1, -1);
      }
      if (process.env[key] === undefined) process.env[key] = value;
    }
  } catch {}
}

async function main() {
  loadDotEnv(path.join(__dirname, '..', '.env'));

  const prisma = new PrismaClient();
  await prisma.$connect();
  try {
    const email = process.env.USER_EMAIL || 'cliente@delicias.com';
    const password = process.env.USER_PASSWORD || 'delicias123';
    const existing = await prisma.usuario.findUnique({ where: { email } });
    if (existing) {
      console.log('[seed-user] Usuario ya existe:', existing.email);
      console.log('[seed-user] Credenciales para la app móvil:');
      console.log('  email:', email);
      console.log('  password:', password);
    } else {
      const hashed = await bcrypt.hash(password, 10);
      const user = await prisma.usuario.create({
        data: {
          nombre: 'Cliente',
          apellido: 'Demo',
          email,
          password: hashed,
          telefono: '999888777',
          direccion: 'Jr. Ejemplo 123',
          activo: true,
        },
        select: { id: true, nombre: true, apellido: true, email: true },
      });
      console.log('[seed-user] Usuario creado:', user.email);
      console.log('[seed-user] Credenciales para la app móvil:');
      console.log('  email:', email);
      console.log('  password:', password);
    }
  } catch (e) {
    console.error('[seed-user] Error:', e);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

main();
