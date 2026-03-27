// Simple seeding script to create an admin if it doesn't exist
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
  // Asegura que DATABASE_URL esté en .env al ejecutar por node (sin prisma CLI)
  loadDotEnv(path.join(__dirname, '..', '.env'));

  const prisma = new PrismaClient();
  await prisma.$connect();
  try {
    const email = process.env.ADMIN_EMAIL || 'admin@delicias.com';
    const password = process.env.ADMIN_PASSWORD || 'Admin123456!';
    const existing = await prisma.administrador.findUnique({ where: { email } });
    if (existing) {
      console.log('[seed-admin] Admin ya existe:', existing.email);
    } else {
      const hashed = await bcrypt.hash(password, 10);
      const admin = await prisma.administrador.create({
        data: {
          nombre: 'Administrador',
          email,
          password: hashed,
          rol: 'super_admin',
          activo: true,
        },
        select: { id: true, nombre: true, email: true, rol: true, activo: true },
      });
      console.log('[seed-admin] Admin creado:', admin);
      console.log('[seed-admin] Credenciales de acceso (DEV):');
      console.log('  email:', email);
      console.log('  password:', password);
    }
  } catch (e) {
    console.error('[seed-admin] Error:', e);
    process.exitCode = 1;
  } finally {
    await prisma.$disconnect();
  }
}

main();