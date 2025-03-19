import 'package:frontend/domain/comment/comment_domain.dart';
import 'package:frontend/domain/comment/local/comment_entity.dart';
import 'package:frontend/infrastructure/comment/comment_dto.dart';

extension CDMapper on CommentDto {
  CommentDto fromComment(CommentEntity comment) {
    try {
      print("Mapping CommentEntity to CommentDto: id = ${comment.id}, body = ${comment.body}, postId = ${comment.postId}, author = ${comment.author}");
      return CommentDto(
        id: comment.id,
        body: comment.body,
        postId: comment.postId,
        author: comment.author,
      );
    } catch (e) {
      print("Error mapping CommentEntity to CommentDto: $e");
      rethrow;
    }
  }

  CommentEntity toCommentEntity() {
    try {
      print("Mapping CommentDto to CommentEntity: id = $id, body = $body, postId = $postId, author = $author");
      return CommentEntity(
        id: id!,
        body: body,
        postId: postId,
        author: author,
      );
    } catch (e) {
      print("Error mapping CommentDto to CommentEntity: $e");
      rethrow;
    }
  }

  CommentDomain fromDto(CommentDto comment) {
    try {
      print("Mapping CommentDto to CommentDomain: id = ${comment.id}, body = ${comment.body}, postId = ${comment.postId}, author = ${comment.author}");
      return CommentDomain(
        id: comment.id,
        body: comment.body,
        postId: comment.postId,
        author: comment.author,
      );
    } catch (e) {
      print("Error mapping CommentDto to CommentDomain: $e");
      rethrow;
    }
  }
}
