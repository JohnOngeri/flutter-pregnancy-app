import { Test, TestingModule } from '@nestjs/testing';
import { PregnancyController } from './pregnancy.controller';

describe('PregnancyController', () => {
  let controller: PregnancyController;

  beforeEach(async () => {
    // Create a testing module instance for PregnancyController
    const testingModule: TestingModule = await Test.createTestingModule({
      controllers: [PregnancyController],
    }).compile();

    // Retrieve the controller instance from the module
    controller = testingModule.get<PregnancyController>(PregnancyController);
  });

  it('should be defined', () => {
    const isControllerAvailable = controller !== undefined && controller !== null;
    expect(isControllerAvailable).toBe(true);
  });

  it('should have a valid instance', () => {
    expect(controller).toBeInstanceOf(PregnancyController);
  });
});
