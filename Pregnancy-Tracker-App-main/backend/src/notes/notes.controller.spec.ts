import { Test, TestingModule } from '@nestjs/testing';
import { NotesController } from './notes.controller';
import { NotesService } from './notes.service';

describe('NotesController', () => {
  let notesController: NotesController;
  let notesService: NotesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [NotesController],
      providers: [NotesService],
    }).compile();

    notesController = module.get<NotesController>(NotesController);
    notesService = module.get<NotesService>(NotesService);
  });

  it('should be defined', () => {
    expect(notesController).toBeDefined();
  });
});
