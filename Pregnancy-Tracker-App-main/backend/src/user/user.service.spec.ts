import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './user.service';

describe('UserService', () => {
  let service: UserService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [UserService],
    }).compile();

    service = module.get<UserService>(UserService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // Example test: Testing a real function that might exist in UserService (like `findAll` or `create`)
  it('should return a list of users', async () => {
    const result = await service.findAll();  // Assuming `findAll` exists in your UserService
    expect(result).toBeInstanceOf(Array); // This checks if the result is an array
  });
});
