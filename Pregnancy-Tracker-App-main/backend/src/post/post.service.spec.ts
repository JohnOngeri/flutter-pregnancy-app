import { Test, TestingModule } from '@nestjs/testing';
import { PostService } from './post.service';

describe('PostService', () => {
  let postService: PostService;

  beforeEach(async () => {
    const testingModule: TestingModule = await Test.createTestingModule({
      providers: [PostService],
    }).compile();

    postService = testingModule.get<PostService>(PostService);
  });

  it('should be instantiated properly', () => {
    expect(postService).toBeDefined();
  });
});
