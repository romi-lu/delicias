import { Controller, Get, HttpException, HttpStatus } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  /** Comprueba que Prisma llegue a Postgres (útil en Railway / Supabase). */
  @Get('health')
  async health() {
    const result = await this.appService.getHealth();
    if (result.database === 'disconnected') {
      throw new HttpException(result, HttpStatus.SERVICE_UNAVAILABLE);
    }
    return result;
  }
}
