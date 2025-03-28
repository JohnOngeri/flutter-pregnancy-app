import { Controller, Get, Post, Body, Patch, Param, Delete, Put, UseGuards, HttpException, HttpStatus } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { AuthGuard } from '@nestjs/passport';

@UseGuards(AuthGuard('jwt'))
@Controller('comments')
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Post()
  async create(@Body() createCommentDto: CreateCommentDto) {
    try {
      return await this.commentsService.createComment(createCommentDto);
    } catch (error) {
      throw new HttpException(`Error creating comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  @Get()
  async findAll() {
    try {
      return await this.commentsService.findAll();
    } catch (error) {
      throw new HttpException(`Error fetching comments: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  @Get('post/:postId')
  async findCommentByPost(@Param('postId') postId: string) {
    try {
      return await this.commentsService.findCommentByPost(postId);
    } catch (error) {
      throw new HttpException(`Error finding comments for post: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  @Get('author/:author')
  async findCommentByAuthor(@Param('author') author: string) {
    try {
      return await this.commentsService.findCommentByAuthor(author);
    } catch (error) {
      throw new HttpException(`Error finding comments by author: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  @Put(':id')
  async updateComment(@Param('id') id: string, @Body() updateCommentDto: CreateCommentDto) {
    try {
      return await this.commentsService.updateComment(id, updateCommentDto);
    } catch (error) {
      throw new HttpException(`Error updating comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  @Delete(':id')
  async removeComment(@Param('id') id: string) {
    try {
      return await this.commentsService.removeComment(id);
    } catch (error) {
      throw new HttpException(`Error removing comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }
}
