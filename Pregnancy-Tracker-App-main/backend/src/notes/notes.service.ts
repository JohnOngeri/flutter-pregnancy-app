import { HttpException, HttpStatus, Injectable, NotFoundException } from '@nestjs/common';
import { CreateNoteDto } from './dto/create-note.dto';
import { Note } from './entities/note.entity';
import { INote } from './notes.interface';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

@Injectable()
export class NotesService {
  constructor(
    @InjectModel(Note.name) private readonly noteModel: Model<INote>
  ) {}

  async findAll(): Promise<Note[]> {
    return this.noteModel.find().exec();
  }

  async create(newNote: CreateNoteDto): Promise<Note> {
    const createdNote = new this.noteModel(newNote);
    const validation = createdNote.validateSync();
    if (validation) {
      throw new HttpException('Bad Request', HttpStatus.BAD_REQUEST);
    }
    return await createdNote.save();
  }

  async findOne(id: string): Promise<Note> {
    const note = await this.noteModel.findById(id).exec();
    if (!note) {
      throw new NotFoundException('Note Not Found');
    }
    return note;
  }

  async findByUser(author: string) {
    const finder = { author: author };
    return await this.noteModel.find(finder).exec();
  }

  async updateNote(id: string, updateCreateNoteDto: CreateNoteDto): Promise<Note> {
    return await this.noteModel.findByIdAndUpdate(id, updateCreateNoteDto, { new: true }).exec();
  }

  async removeNote(id: string): Promise<any> {
    return await this.noteModel.deleteOne({ _id: id }).exec();
  }
}