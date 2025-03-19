import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnauthorizedException } from '@nestjs/common';
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    console.log("🔍 JWT Payload:", payload); // Debugging: Log payload
  
    if (!payload.profileId) {
      throw new UnauthorizedException("Profile ID is missing in authentication");
    }
  
    return {
      userId: payload.sub, // Ensure correct field mapping
      userName: payload.userName,
      email: payload.email,
      profileId: payload.profileId, // ✅ Ensure this is always included
    };
  }
}