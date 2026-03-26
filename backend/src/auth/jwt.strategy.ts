import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(config: ConfigService) {
    const secret = config.get<string>('JWT_SECRET');
    if (!secret?.trim()) {
      throw new Error(
        'JWT_SECRET no está definido. Añádelo en Variables del servicio (Railway: JWT_SECRET=una_cadena_larga_y_aleatoria).',
      );
    }
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: secret,
    });
  }

  async validate(payload: { id: number; email: string; tipo: 'usuario' | 'admin' }) {
    return payload;
  }
}