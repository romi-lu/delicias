/** Mapea fallos de conexión Prisma a respuesta HTTP sin filtrar secretos. */
export function httpResponseForDbFailure(error: unknown): {
  status: number;
  body: { error: string; message: string; code?: string };
} | null {
  const msg = error instanceof Error ? error.message : String(error);
  const code =
    error && typeof error === 'object' && 'code' in error
      ? String((error as { code: unknown }).code)
      : undefined;
  const connectionLike =
    code === 'P1001' ||
    code === 'P1000' ||
    code === 'P1017' ||
    msg.includes("Can't reach database") ||
    msg.includes('Server has closed the connection') ||
    /P1001/i.test(msg);
  if (!connectionLike) return null;
  return {
    status: 503,
    body: {
      error: 'Base de datos',
      message:
        'Sin conexión a PostgreSQL. Revisa DATABASE_URL en el servicio del backend (Railway). Con Supabase: URL del pooler (puerto 6543), no db.*.supabase.co:5432; añade sslmode=require y, si usas pooler de transacciones, pgbouncer=true. Codifica caracteres especiales de la contraseña en la URL.',
      ...(code ? { code } : {}),
    },
  };
}
