import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/infrastructure/comment/comment_dto.dart';
import 'package:frontend/infrastructure/comment/comment_form_dto.dart';
import 'package:frontend/infrastructure/comment/comment_form_mapper.dart';
import 'package:frontend/local_data/shared_preferences/jj_shared_preferences_service.dart';
import 'package:frontend/util/jj_http_client.dart';
import 'package:frontend/util/jj_http_exception.dart';
import 'package:frontend/util/jj_timeout_exception.dart';

class CommentAPI {
  JJHttpClient _customHttpClient = JJHttpClient();
  SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();

  Future<CommentDto> createComment(CommentFormDto commentFormDto) async {
    try {
      String author = await _sharedPreferenceService.getProfileId() ?? "";

      if (author == "") {
        debugPrint("CommentAPI: User not logged in.");
        throw JJHttpException("Not Logged In", 404);
      }

      debugPrint("CommentAPI: Creating comment for author $author.");
      var response = await _customHttpClient.post(
        "comments",
        body: json.encode(commentFormDto.toAuthoredDto(author).toJson()),
      );

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode == 201) {
        debugPrint("CommentAPI: Comment created successfully.");
        return CommentDto.fromJson(jsonDecode(response.body));
      } else {
        debugPrint("CommentAPI: Failed to create comment - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in createComment - $e");
      debugPrint(stackTrace.toString());
      throw e;
    }
  }

  Future<CommentDto> updateComment(CommentFormDto commentFormDto, String id) async {
    try {
      debugPrint("CommentAPI: Updating comment with ID $id.");
      var response = await _customHttpClient.put(
        "comments/$id",
        body: json.encode(commentFormDto.toJson()),
      );

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode == 201) {
        debugPrint("CommentAPI: Comment updated successfully.");
        return CommentDto.fromJson(jsonDecode(response.body));
      } else {
        debugPrint("CommentAPI: Failed to update comment - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in updateComment - $e");
      debugPrint(stackTrace.toString());
      throw e;
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      debugPrint("CommentAPI: Deleting comment with ID $id.");
      var response = await _customHttpClient.delete("comments/$id");

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode != 204) {
        debugPrint("CommentAPI: Failed to delete comment - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      } else {
        debugPrint("CommentAPI: Comment deleted successfully.");
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in deleteComment - $e");
      debugPrint(stackTrace.toString());
      throw e;
    }
  }

  Future<List<CommentDto>> getComments() async {
    try {
      debugPrint("CommentAPI: Fetching all comments.");
      var response = await _customHttpClient.get("comments");

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode == 201) {
        debugPrint("CommentAPI: Comments retrieved successfully.");
        return (jsonDecode(response.body) as List)
            .map((e) => CommentDto.fromJson(e))
            .toList();
      } else {
        debugPrint("CommentAPI: Failed to fetch comments - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in getComments - $e");
      debugPrint(stackTrace.toString());
      throw e;
    }
  }

  Future<CommentDto> getOneComment(String id) async {
    try {
      debugPrint("CommentAPI: Fetching comment with ID $id.");
      var response = await _customHttpClient.get("comments/$id");

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode == 201 && response.body != null) {
        debugPrint("CommentAPI: Comment retrieved successfully.");
        return CommentDto.fromJson(jsonDecode(response.body));
      } else if (response.body == null) {
        debugPrint("CommentAPI: Comment not found.");
        throw JJHttpException("Comment not found", response.statusCode);
      } else {
        debugPrint("CommentAPI: Failed to fetch comment - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in getOneComment - $e");
      debugPrint(stackTrace.toString());
      throw e;
    }
  }

  Future<List<CommentDto>> getCommentsByUser(String author) async {
    try {
      debugPrint("CommentAPI: Fetching comments for user $author.");
      var response = await _customHttpClient
          .get("comments/user/$author")
          .timeout(jjTimeout);

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("CommentAPI: Comments retrieved successfully.");
        return (jsonDecode(response.body) as List)
            .map((e) => CommentDto.fromJson(e))
            .toList();
      } else {
        debugPrint("CommentAPI: Failed to fetch user comments - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in getCommentsByUser - $e");
      debugPrint(stackTrace.toString());
      throw JJTimeoutException();
    }
  }

  Future<List<CommentDto>> getCommentsByPost(String postId) async {
    try {
      debugPrint("CommentAPI: Fetching comments for post $postId.");
      var response = await _customHttpClient
          .get("comments/post/$postId")
          .timeout(jjTimeout);

      debugPrint("CommentAPI: Response status code - ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint("CommentAPI: Comments retrieved successfully.");
        return (jsonDecode(response.body) as List)
            .map((e) => CommentDto.fromJson(e))
            .toList();
      } else {
        debugPrint("CommentAPI: Failed to fetch post comments - ${response.body}");
        throw JJHttpException(
            json.decode(response.body)['message'] ?? "Unknown error",
            response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint("CommentAPI: Exception in getCommentsByPost - $e");
      debugPrint(stackTrace.toString());
      throw JJTimeoutException();
    }
  }
}
