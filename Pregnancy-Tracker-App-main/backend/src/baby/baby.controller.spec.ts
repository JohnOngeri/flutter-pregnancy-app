import { Test, TestingModule } from '@nestjs/testing';
import { BabyController } from './baby.controller';

describe('BabyController', () => {
  let babyController: BabyController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BabyController],
    }).compile();

    babyController = module.get<BabyController>(BabyController);
  });

  it('should be defined', () => {
    expect(babyController).toBeDefined();
  });
});
