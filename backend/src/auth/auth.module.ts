import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './jwt.strategy';

function jwtSecretOrThrow(config: ConfigService): string {
  const secret = config.get<string>('JWT_SECRET');
  if (!secret?.trim()) {
    throw new Error(
      'JWT_SECRET no está definido. Añádelo en Variables del servicio (Railway: JWT_SECRET=una_cadena_larga_y_aleatoria).',
    );
  }
  return secret;
}

@Module({
  imports: [
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        secret: jwtSecretOrThrow(config),
        signOptions: { expiresIn: '24h' },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
})
export class AuthModule {}