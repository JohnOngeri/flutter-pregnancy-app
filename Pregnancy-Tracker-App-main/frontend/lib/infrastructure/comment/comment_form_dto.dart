import 'dart:convert';

class CommentFormDto {
  final String body;
  final String postId;

  CommentFormDto({
    required this.body,
    required this.postId,
  });

  factory CommentFormDto.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing CommentFormDto from JSON: $json");
      return CommentFormDto(
        body: json['body'],
        postId: json['postId'],
      );
    } catch (e) {
      print("Error parsing CommentFormDto: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      final jsonData = {
        'body': body,
        'postId': postId,
      };
      print("Converting CommentFormDto to JSON: $jsonData");
      return jsonData;
    } catch (e) {
      print("Error converting CommentFormDto to JSON: $e");
      rethrow;
    }
  }
}
