import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';

@Injectable()
export class AppService {
  constructor(private readonly prisma: PrismaService) {}

  getHello(): string {
    return 'Hello World!';
  }

  async getHealth(): Promise<{
    status: 'ok' | 'degraded';
    database: 'connected' | 'disconnected';
    prismaCode?: string;
    hint?: string;
  }> {
    try {
      // Evita prepared statements: con PgBouncer (pool "Transaction" de Supabase) el tagged
      // `$queryRaw\`SELECT 1\`` puede provocar P2010.
      await this.prisma.$queryRawUnsafe('SELECT 1');
      return { status: 'ok', database: 'connected' };
    } catch (e: unknown) {
      const code =
        e && typeof e === 'object' && 'code' in e ? String((e as { code: unknown }).code) : undefined;
      const meta =
        e && typeof e === 'object' && 'meta' in e && typeof (e as { meta: unknown }).meta === 'object'
          ? ((e as { meta: Record<string, unknown> }).meta as Record<string, unknown>)
          : {};
      const dbMessage =
        meta.message != null ? String(meta.message).slice(0, 240) : undefined;

      let hint =
        'Variable DATABASE_URL solo en el servicio Nest (backend). Supabase: connection string "Transaction" / pooler :6543; evita host db.*.supabase.co:5432 desde Railway.';
      if (code === 'P2010') {
        hint =
          'P2010 con Supabase + Prisma: en DATABASE_URL añade pgbouncer=true y sslmode=require (cadena del pooler, puerto 6543). Sin pgbouncer=true, Prisma y el pooler suelen chocar (prepared statements).';
      }

      return {
        status: 'degraded',
        database: 'disconnected',
        ...(code ? { prismaCode: code } : {}),
        ...(dbMessage ? { dbMessage } : {}),
        hint,
      };
    }
  }
}
