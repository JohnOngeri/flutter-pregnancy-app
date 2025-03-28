import { Test, TestingModule } from '@nestjs/testing';
import { UserController } from './user.controller';
import { UserService } from './user.service';

describe('UserController', () => {
  let userController: UserController; // Changed variable name for consistency

  beforeEach(async () => {
    const testingModule: TestingModule = await Test.createTestingModule({ // Renamed to make the name more consistent
      controllers: [UserController],
      providers: [UserService],
    }).compile();

    userController = testingModule.get<UserController>(UserController); // Updated the variable name
  });

  it('should be defined', () => {
    expect(userController).toBeDefined(); // Used the updated variable name
  });
});
