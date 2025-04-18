import 'package:frontend/domain/note/note_failure.dart';

class NoteDomain {
  String? id;
  final String body;
  final String title;
  final String author;

  NoteDomain({
    this.id,
    required this.body,
    required this.title,
    required this.author,
  });

 factory NoteDomain.fromJson(Map<String, dynamic> json) {
  return NoteDomain(
    id: json['id']?.toString(),  // Converts `null` safely to a String
    body: json['body'] ?? '',     // Provides default empty string
    title: json['title'] ?? 'Untitled',
    author: json['author'] ?? 'Unknown',
  );
}


  @override
  String toString() {
    return 'NoteDomain(id: $id, body: $body, title: $title, userId: $author)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteDomain &&
        other.id == id &&
        other.body == body &&
        other.title == title &&
        other.author == author;
  }

  @override
  int get hashCode {
    return id.hashCode ^ body.hashCode ^ title.hashCode ^ author.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'title': title,
      'author': author,
    };
  }

  void validate() {
    if (body.isEmpty) {
      throw ValidationError('Body cannot be empty');
    }

    if (title.isEmpty) {
      throw ValidationError('Title cannot be empty');
    }

    if (author.isEmpty) {
      throw ValidationError('Author cannot be empty');
    }
  }
}
