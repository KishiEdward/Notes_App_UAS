import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String category;
  final bool isPinned;
  final bool isTrashed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reminderDate;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.category = 'All',
    this.isPinned = false,
    this.isTrashed = false,
    required this.createdAt,
    required this.updatedAt,
    this.reminderDate,
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
      category: data['category']?.toString() ?? 'All',
      isPinned: data['isPinned'] ?? false,
      isTrashed: data['isTrashed'] ?? false,
      createdAt: toDateTime(data['createdAt']),
      updatedAt: toDateTime(data['updatedAt']),
      reminderDate: data['reminderDate'] != null ? toDateTime(data['reminderDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'isTrashed': isTrashed,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reminderDate': reminderDate,
    };
  }
}