import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateCommentDto } from './dto/create-comment.dto';
import { Comment } from './schema/comment.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { PostService } from 'src/post/post.service';
import { ProfileService } from 'src/profile/profile.service';

@Injectable()
export class CommentsService {
  constructor(
    @InjectModel(Comment.name) private commentModel: Model<Comment>,
    private postService: PostService,
    private profileService: ProfileService
  ) {}

  async createComment(createCommentDto: CreateCommentDto) {
    try {
      const newComment = new this.commentModel(createCommentDto);
      
      // Update the post
      const reqPost = await this.postService.findOne(createCommentDto.postId);
      if (reqPost) {
        reqPost.comments.push(newComment._id.toString());
        await this.postService.updatePost(createCommentDto.postId, { comments: reqPost.comments });
      }

      // Update the profile
      const reqProfile = await this.profileService.findOne(createCommentDto.author);
      if (reqProfile) {
        reqProfile.comments.push(newComment._id.toString());
        await this.profileService.updateProfile(createCommentDto.author, { comments: reqProfile.comments });
      }

      return await newComment.save();
    } catch (error) {
      throw new HttpException(`Couldn't create comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async findCommentByPost(id: string) {
    try {
      return await this.commentModel.find({ postId: id });
    } catch (error) {
      throw new HttpException(`Couldn't find comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async findAll() {
    try {
      return await this.commentModel.find();
    } catch (error) {
      throw new HttpException(`Couldn't find comments: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async findCommentByAuthor(id: string) {
    try {
      return await this.commentModel.find({ author: id });
    } catch (error) {
      throw new HttpException(`Couldn't find comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async updateComment(id: string, updateCommentDto: CreateCommentDto) {
    try {
      return await this.commentModel.findByIdAndUpdate(id, updateCommentDto, { new: true }).exec();
    } catch (error) {
      throw new HttpException(`Couldn't update comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async removeComment(id: string) {
    try {
      const deletedComment = await this.commentModel.findByIdAndDelete(id);
      if (!deletedComment) {
        throw new HttpException("Comment not found", HttpStatus.NOT_FOUND);
      }
      
      // Update the post
      const reqPost = await this.postService.findOne(deletedComment.postId);
      if (reqPost) {
        const filteredComments = reqPost.comments.filter(commentId => commentId !== deletedComment._id.toString());
        if (filteredComments.length === 1) {
          reqPost.comments = [filteredComments[0]];
        } else {
          throw new HttpException("Post must have exactly one comment", HttpStatus.BAD_REQUEST);
        }
        await this.postService.updatePost(deletedComment.postId, { comments: reqPost.comments });
      }

      // Update the profile
      const reqProfile = await this.profileService.findOne(deletedComment.author);
      if (reqProfile) {
        reqProfile.comments = reqProfile.comments.filter(commentId => commentId !== deletedComment._id.toString());
        await this.profileService.updateProfile(deletedComment.author, { comments: reqProfile.comments });
      }

      return deletedComment;
    } catch (error) {
      throw new HttpException(`Couldn't delete comment: ${error.message}`, HttpStatus.BAD_REQUEST);
    }
  }
}
