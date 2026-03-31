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
      await this.prisma.$queryRaw`SELECT 1`;
      return { status: 'ok', database: 'connected' };
    } catch (e: unknown) {
      const code =
        e && typeof e === 'object' && 'code' in e ? String((e as { code: unknown }).code) : undefined;
      return {
        status: 'degraded',
        database: 'disconnected',
        ...(code ? { prismaCode: code } : {}),
        hint:
          'Variable DATABASE_URL solo en el servicio Nest (backend). Supabase: connection string "Transaction" / pooler :6543; evita host db.*.supabase.co:5432 desde Railway.',
      };
    }
  }
}
