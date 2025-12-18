import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic>? data, String documentId) {
    data = data ?? {};
    
    DateTime toDateTime(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      return DateTime.now();
    }

    return Note(
      id: documentId,
      userId: data['userId']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      content: data['content']?.toString() ?? '',
      createdAt: toDateTime(data['createdAt']),
      updatedAt: toDateTime(data['updatedAt']),
    );
  }
}
