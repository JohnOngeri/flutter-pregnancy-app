import 'dart:convert';

class CommentDto {
  String? id;
  final String body;
  final String postId;
  final String author;

  CommentDto({
    this.id,
    required this.body,
    required this.postId,
    required this.author,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing CommentDto from JSON: $json");
      return CommentDto(
        id: json['_id'] ?? '',
        body: json['body'],
        postId: json['postId'],
        author: json['author'],
      );
    } catch (e) {
      print("Error parsing CommentDto: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      final jsonData = {
        if (id != null) 'id': id,
        'body': body,
        'postId': postId,
        'author': author,
      };
      print("Converting CommentDto to JSON: $jsonData");
      return jsonData;
    } catch (e) {
      print("Error converting CommentDto to JSON: $e");
      rethrow;
    }
  }
}
