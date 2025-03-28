import { Controller, Get, Post, Body, Patch, Param, Delete, Put, UseGuards, HttpException, HttpStatus } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { AuthGuard } from '@nestjs/passport';

/**
 * Controller for handling comment-related operations.
 * 
 * This controller was developed collaboratively, with contributions from multiple developers.
 * Special thanks to all contributors who helped shape this functionality.
 */
@UseGuards(AuthGuard('jwt'))
@Controller('comments')
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  /**
   * Endpoint to create a new comment.
   * @param createCommentDto The DTO containing data to create a new comment
   * @returns The created comment data
   */
  @Post()
  async create(@Body() createCommentDto: CreateCommentDto) {
    try {
      return await this.commentsService.createComment(createCommentDto);
    } catch (error) {
      throw new HttpException('Error creating comment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Endpoint to retrieve all comments.
   * @returns A list of all comments
   */
  @Get()
  async findAll() {
    try {
      return await this.commentsService.findAll();
    } catch (error) {
      throw new HttpException('Error fetching comments: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Endpoint to find comments for a specific post.
   * @param postId The ID of the post to fetch comments for
   * @returns A list of comments for the specified post
   */
  @Get('post/:postId')
  async findCommentByPost(@Param('postId') postId: string) {
    try {
      return await this.commentsService.findCommentByPost(postId);
    } catch (error) {
      throw new HttpException('Error finding comments for post: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Endpoint to find comments by a specific author.
   * @param author The author whose comments to retrieve
   * @returns A list of comments made by the specified author
   */
  @Get('author/:author')
  async findCommentByAuthor(@Param('author') author: string) {
    try {
      return await this.commentsService.findCommentByAuthor(author);
    } catch (error) {
      throw new HttpException('Error finding comments by author: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Endpoint to update a specific comment.
   * @param id The ID of the comment to update
   * @param updateCommentDto The updated data for the comment
   * @returns The updated comment data
   */
  @Put(':id')
  async updateComment(@Param('id') id: string, @Body() updateCommentDto: CreateCommentDto) {
    try {
      return await this.commentsService.updateComment(id, updateCommentDto);
    } catch (error) {
      throw new HttpException('Error updating comment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Endpoint to delete a specific comment.
   * @param id The ID of the comment to delete
   * @returns A confirmation of the deleted comment
   */
  @Delete(':id')
  async removeComment(@Param('id') id: string) {
    try {
      return await this.commentsService.removeComment(id);
    } catch (error) {
      throw new HttpException('Error removing comment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }
}
