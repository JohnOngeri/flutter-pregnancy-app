import 'dart:io';
import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:frontend/domain/comment/comment_domain.dart';
import 'package:frontend/domain/comment/comment_failure.dart';
import 'package:frontend/domain/comment/comment_form.dart';
import 'package:frontend/domain/comment/comment_repository_interface.dart';
import 'package:frontend/infrastructure/comment/comment_api.dart';
import 'package:frontend/infrastructure/comment/comment_dto.dart';
import 'package:frontend/infrastructure/comment/comment_form_mapper.dart';
import 'package:frontend/infrastructure/comment/comment_mapper.dart';
import 'package:frontend/local_data/database/jj_database_helper.dart';
import 'package:frontend/util/jj_timeout_exception.dart';
import 'package:http/http.dart';

class CommentRepository implements CommentRepositoryInterface {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final CommentAPI commentApi;

  CommentRepository(this.commentApi);

  @override
  Future<Either<CommentFailure, List<CommentDomain>>> getCommentsForPost(
      String postId) async {
    developer.log('Fetching comments for post with ID: $postId', name: 'CommentRepository');
    try {
      List<CommentDto> comments = await commentApi.getCommentsByPost(postId);
      developer.log('Successfully fetched ${comments.length} comments from API for post ID: $postId', name: 'CommentRepository');
      
      await databaseHelper.addComments(comments);
      developer.log('Successfully added comments to database for post ID: $postId', name: 'CommentRepository');

      return Right(
          comments.map((e) => CommentDomain.fromJson(e.toJson())).toList());
    } on JJTimeoutException catch (timeout) {
      developer.log('Timeout occurred while fetching comments for post ID: $postId', name: 'CommentRepository');
      var comments = await databaseHelper.getCommentsByPost(postId);
      if (comments.isEmpty) {
        developer.log('No comments found in database for post ID: $postId', name: 'CommentRepository');
        return left(CommentFailure.serverError());
      } else {
        developer.log('Fetched ${comments.length} comments from database for post ID: $postId', name: 'CommentRepository');
        return right(comments);
      }
    } on ServerError catch (e) {
      developer.log('Server error occurred while fetching comments for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while fetching comments for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while fetching comments for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comments not found for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while fetching comments for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while fetching comments for post ID: $postId', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while fetching comments for post ID: $postId: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while fetching comments for post ID: $postId: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }

  @override
  Future<Either<CommentFailure, CommentDomain>> addComment(
      CommentForm commentForm) async {
    developer.log('Adding new comment', name: 'CommentRepository');
    try {
      var comment = await commentApi.createComment(commentForm.toDto());
      developer.log('Successfully created comment with ID: ${comment.id}', name: 'CommentRepository');
      
      await databaseHelper.addComments([comment]);
      developer.log('Successfully added comment to database with ID: ${comment.id}', name: 'CommentRepository');

      return right(CommentDomain.fromJson(comment.toJson()));
    } on ServerError catch (e) {
      developer.log('Server error occurred while adding comment', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while adding comment', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while adding comment', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comment not found while adding comment', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while adding comment', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while adding comment', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while adding comment: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while adding comment: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }

  @override
  Future<Either<CommentFailure, CommentDomain>> updateComment(
      {required CommentForm commentForm, required String commentId}) async {
    developer.log('Updating comment with ID: $commentId', name: 'CommentRepository');
    try {
      var commentDomainDto =
          await commentApi.updateComment(commentForm.toDto(), commentId);
      developer.log('Successfully updated comment with ID: $commentId', name: 'CommentRepository');
      
      await databaseHelper.updateComment(commentDomainDto.toCommentEntity());
      developer.log('Successfully updated comment in database with ID: $commentId', name: 'CommentRepository');

      return right(CommentDomain.fromJson(commentDomainDto.toJson()));
    } on ServerError catch (e) {
      developer.log('Server error occurred while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comment not found while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while updating comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while updating comment with ID: $commentId: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while updating comment with ID: $commentId: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }

  @override
  Future<Either<CommentFailure, Unit>> deleteComment(String commentId) async {
    developer.log('Deleting comment with ID: $commentId', name: 'CommentRepository');
    try {
      await databaseHelper.removeComment(commentId);
      developer.log('Successfully removed comment from database with ID: $commentId', name: 'CommentRepository');
      
      await commentApi.deleteComment(commentId);
      developer.log('Successfully deleted comment from API with ID: $commentId', name: 'CommentRepository');

      return right(unit);
    } on ServerError catch (e) {
      developer.log('Server error occurred while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comment not found while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while deleting comment with ID: $commentId', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while deleting comment with ID: $commentId: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while deleting comment with ID: $commentId: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }

  @override
  Future<Either<CommentFailure, List<CommentDomain>>> getUserComments(
      String userId) async {
    developer.log('Fetching comments for user with ID: $userId', name: 'CommentRepository');
    try {
      List<CommentDto> comments = await commentApi.getCommentsByUser(userId);
      developer.log('Successfully fetched ${comments.length} comments from API for user ID: $userId', name: 'CommentRepository');
      
      await databaseHelper.addComments(comments);
      developer.log('Successfully added comments to database for user ID: $userId', name: 'CommentRepository');

      return Right(
          comments.map((e) => CommentDomain.fromJson(e.toJson())).toList());
    } on JJTimeoutException catch (timeout) {
      developer.log('Timeout occurred while fetching comments for user ID: $userId', name: 'CommentRepository');
      var comments = await databaseHelper.getCommentsByUser(userId);
      if (comments.isEmpty) {
        developer.log('No comments found in database for user ID: $userId', name: 'CommentRepository');
        return left(CommentFailure.serverError());
      } else {
        developer.log('Fetched ${comments.length} comments from database for user ID: $userId', name: 'CommentRepository');
        return right(comments);
      }
    } on ServerError catch (e) {
      developer.log('Server error occurred while fetching comments for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while fetching comments for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while fetching comments for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comments not found for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while fetching comments for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while fetching comments for user ID: $userId', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while fetching comments for user ID: $userId: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while fetching comments for user ID: $userId: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }

  @override
  Future<Either<CommentFailure, List<CommentDomain>>> getComments() async {
    developer.log('Fetching all comments', name: 'CommentRepository');
    try {
      var allComments = await databaseHelper.getComments();
      developer.log('Fetched ${allComments.length} comments from database', name: 'CommentRepository');

      if (allComments.isEmpty) {
        developer.log('No comments found in database, fetching from API', name: 'CommentRepository');
        List<CommentDto> commentsDto = await commentApi.getComments();
        developer.log('Successfully fetched ${commentsDto.length} comments from API', name: 'CommentRepository');
        
        await databaseHelper.addComments(commentsDto);
        developer.log('Successfully added comments to database', name: 'CommentRepository');
        
        allComments = await databaseHelper.getComments();
        developer.log('Fetched ${allComments.length} comments from database after adding', name: 'CommentRepository');
      }

      return Right(allComments);
    } on ServerError catch (e) {
      developer.log('Server error occurred while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.serverError());
    } on NetworkError catch (e) {
      developer.log('Network error occurred while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.networkError());
    } on Unauthorized catch (e) {
      developer.log('Unauthorized access while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.unauthorized());
    } on NotFound catch (e) {
      developer.log('Comments not found while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.notFound());
    } on PermissionDenied catch (e) {
      developer.log('Permission denied while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.permissionDenied());
    } on Forbidden catch (e) {
      developer.log('Forbidden access while fetching all comments', name: 'CommentRepository');
      return left(CommentFailure.forbidden());
    } on ValidationError catch (e) {
      developer.log('Validation error occurred while fetching all comments: ${e.message}', name: 'CommentRepository');
      return left(CommentFailure.validationError(e.message));
    } catch (e) {
      developer.log('Unexpected error occurred while fetching all comments: ${e.toString()}', name: 'CommentRepository');
      return left(CommentFailure.customError(e.toString()));
    }
  }
}