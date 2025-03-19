import 'package:frontend/domain/appointment/appointment_form.dart';
import 'package:frontend/domain/comment/comment_form.dart';
import 'package:frontend/infrastructure/appointment/appointment_form_dto.dart';
import 'package:frontend/infrastructure/comment/comment_dto.dart';
import 'package:frontend/infrastructure/comment/comment_form_dto.dart';

extension CFMapper on CommentForm {
  CommentFormDto toDto() {
    try {
      print("Mapping CommentForm to CommentFormDto: body = $body, postId = $postId");
      return CommentFormDto(
        body: body,
        postId: postId,
      );
    } catch (e) {
      print("Error mapping CommentForm to CommentFormDto: $e");
      rethrow;
    }
  }
}

extension CFMapper2 on CommentFormDto {
  CommentDto toAuthoredDto(String author) {
    try {
      print("Mapping CommentFormDto to CommentDto with author: $author");
      return CommentDto(
        body: body,
        postId: postId,
        author: author,
      );
    } catch (e) {
      print("Error mapping CommentFormDto to CommentDto: $e");
      rethrow;
    }
  }
}
