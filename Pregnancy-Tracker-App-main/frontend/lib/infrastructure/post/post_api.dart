import 'dart:convert';
import 'package:frontend/infrastructure/post/post_dto.dart';
import 'package:frontend/infrastructure/post/post_form_dto.dart';
import 'package:frontend/infrastructure/post/post_form_mapper.dart';
import 'package:frontend/local_data/shared_preferences/jj_shared_preferences_service.dart';
import 'package:frontend/util/jj_http_client.dart';
import 'package:frontend/util/jj_http_exception.dart';
import 'package:frontend/util/jj_timeout_exception.dart';

class PostAPI {
  JJHttpClient jjHttpClient = JJHttpClient();
  SharedPreferenceService sharedPreferences = SharedPreferenceService();

  Future<PostDto> createPost(PostFormDto postFormDto) async {
    print("PostAPI: createPost called");
    String author = await sharedPreferences.getProfileId() ?? "";
    print("PostAPI: Retrieved author ID: $author");

    if (author == "") {
      print("PostAPI: Error - Not Logged In");
      throw JJHttpException("Not Logged In", 404);
    }

    var postDto = postFormDto.toAuthoredDto(author);
    print("PostAPI: Converted PostFormDto to PostDto: ${postDto.toJson()}");

    var post =
        await jjHttpClient.post("post", body: json.encode(postDto.toJson()));
    print("PostAPI: POST request sent to 'post' endpoint. Status code: ${post.statusCode}");

    if (post.statusCode == 201) {
      print("PostAPI: Post created successfully. Response: ${post.body}");
      return PostDto.fromJson(jsonDecode(post.body));
    } else {
      print("PostAPI: Error creating post. Response: ${post.body}");
      throw JJHttpException(
          json.decode(post.body)['message'] ?? "Unknown error",
          post.statusCode);
    }
  }

  Future<PostDto> updatePost(PostFormDto postFormDto, String postId) async {
    print("PostAPI: updatePost called for postId: $postId");
    String author = await sharedPreferences.getProfileId() ?? "";
    print("PostAPI: Retrieved author ID: $author");

    if (author == "") {
      print("PostAPI: Error - Not Logged In");
      throw JJHttpException("Not Logged In", 404);
    }

    var updatedPost = await jjHttpClient.put("post/$postId",
        body: json.encode(postFormDto.toAuthoredDto(author).toJson()));
    print("PostAPI: PUT request sent to 'post/$postId' endpoint. Status code: ${updatedPost.statusCode}");

    if (updatedPost.statusCode >= 200 && updatedPost.statusCode < 300) {
      print("PostAPI: Post updated successfully. Response: ${updatedPost.body}");
      return PostDto.fromJson(jsonDecode(updatedPost.body));
    } else {
      print("PostAPI: Error updating post. Response: ${updatedPost.body}");
      throw JJHttpException(
          json.decode(updatedPost.body)['message'] ?? "Unknown error",
          updatedPost.statusCode);
    }
  }

  Future<void> deletePost(String postId) async {
    print("PostAPI: deletePost called for postId: $postId");
    var response = await jjHttpClient.delete("post/$postId");
    print("PostAPI: DELETE request sent to 'post/$postId' endpoint. Status code: ${response.statusCode}");

    if (response.statusCode < 200 || response.statusCode >= 300) {
      print("PostAPI: Error deleting post. Response: ${response.body}");
      throw JJHttpException(
          json.decode(response.body)['message'] ?? "Unknown error",
          response.statusCode);
    }
  }

  Future<List<PostDto>> getPosts() async {
    print("PostAPI: getPosts called");
    try {
      var posts = await jjHttpClient.get("post").timeout(jjTimeout);
      print("PostAPI: GET request sent to 'post' endpoint. Status code: ${posts.statusCode}");

      if (posts.statusCode >= 200 && posts.statusCode < 300) {
        print("PostAPI: Posts retrieved successfully. Response: ${posts.body}");
        return (jsonDecode(posts.body) as List)
            .map((e) => PostDto.fromJson(e))
            .toList();
      } else {
        print("PostAPI: Error retrieving posts. Response: ${posts.body}");
        throw JJHttpException(
            json.decode(posts.body)['message'] ?? "Unknown error",
            posts.statusCode);
      }
    } catch (e) {
      print("PostAPI: Exception in getPosts: $e");
      throw JJTimeoutException();
    }
  }

  Future<PostDto> getOnePost(String id) async {
    print("PostAPI: getOnePost called for postId: $id");
    var post = await jjHttpClient.get("post$id");
    print("PostAPI: GET request sent to 'post$id' endpoint. Status code: ${post.statusCode}");

    if (post.statusCode == 201 && post.body != null) {
      print("PostAPI: Post retrieved successfully. Response: ${post.body}");
      return PostDto.fromJson(jsonDecode(post.body));
    } else if (post.body == null) {
      print("PostAPI: Error - Post not found");
      throw JJHttpException("Post not found", post.statusCode);
    } else {
      print("PostAPI: Error retrieving post. Response: ${post.body}");
      throw JJHttpException(
          json.decode(post.body)['message'] ?? "Unknown error",
          post.statusCode);
    }
  }

  Future<List<PostDto>> getPostByUser(String author) async {
    print("PostAPI: getPostByUser called for author: $author");
    var posts = await jjHttpClient.get("post/author/$author");
    print("PostAPI: GET request sent to 'post/author/$author' endpoint. Status code: ${posts.statusCode}");

    if (posts.statusCode >= 200 && posts.statusCode < 300) {
      print("PostAPI: Posts retrieved successfully. Response: ${posts.body}");
      return (jsonDecode(posts.body) as List)
          .map((e) => PostDto.fromJson(e))
          .toList();
    } else {
      print("PostAPI: Error retrieving posts by user. Response: ${posts.body}");
      throw JJHttpException(
          json.decode(posts.body)['message'] ?? "Unknown error",
          posts.statusCode);
    }
  }

  Future<PostDto> changeLike(String liker, String postId) async {
    print("PostAPI: changeLike called for postId: $postId by liker: $liker");
    var post = await jjHttpClient.patch("post/like/$postId",
        body: json.encode({"liker": liker}));
    print("PostAPI: PATCH request sent to 'post/like/$postId' endpoint. Status code: ${post.statusCode}");

    if (post.statusCode == 201) {
      print("PostAPI: Like updated successfully. Response: ${post.body}");
      return PostDto.fromJson(jsonDecode(post.body));
    } else {
      print("PostAPI: Error updating like. Response: ${post.body}");
      throw JJHttpException(
          json.decode(post.body)['message'] ?? "Unknown error",
          post.statusCode);
    }
  }
}