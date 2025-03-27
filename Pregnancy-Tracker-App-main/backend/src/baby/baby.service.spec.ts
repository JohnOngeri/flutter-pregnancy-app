import { Test, TestingModule } from '@nestjs/testing';
import { BabyService } from './baby.service';

describe('BabyService', () => {
  let service: BabyService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [BabyService], // Services should be in providers, not controllers
    }).compile();

    service = module.get<BabyService>(BabyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
