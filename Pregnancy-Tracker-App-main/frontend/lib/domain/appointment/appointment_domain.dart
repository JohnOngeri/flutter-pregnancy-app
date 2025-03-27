import 'package:frontend/domain/appointment/appointment.dart';

class AppointmentDomain {
  String? id;
  final String title;
  final String body;
  final String date;
  final String time;
  final String author;

  AppointmentDomain({
    this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    required this.author,
  });

  factory AppointmentDomain.fromJson(Map<String, dynamic> json) {
  return AppointmentDomain(
    id: json['id']?.toString(),  // Convert to string safely
    title: json['title'] ?? 'Untitled', 
    body: json['body'] ?? '',
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    author: json['author'] ?? 'Unknown',
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'date': date,
      'time': time,
      'author': author,
    };
  }

  void validate() {
    if (title.isEmpty) {
      throw ValidationError('Title cannot be empty');
    }

    if (body.isEmpty) {
      throw ValidationError('Body cannot be empty');
    }

    if (date.isEmpty) {
      throw ValidationError('Date cannot be empty');
    }

    if (time.isEmpty) {
      throw ValidationError('Time cannot be empty');
    }

    if (author.isEmpty) {
      throw ValidationError('Author cannot be empty');
    }
  }
}
