import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/services/firestore_service.dart';

class NotificationService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<Note>> getUpcomingReminders() async {
    final notes = await _firestoreService.getAllNotes();
    final now = DateTime.now();
    
    return notes.where((note) {
      if (note.reminderDate == null) return false;
      return note.reminderDate!.isAfter(now);
    }).toList()
      ..sort((a, b) => a.reminderDate!.compareTo(b.reminderDate!));
  }

  Future<List<Note>> getOverdueReminders() async {
    final notes = await _firestoreService.getAllNotes();
    final now = DateTime.now();
    
    return notes.where((note) {
      if (note.reminderDate == null) return false;
      return note.reminderDate!.isBefore(now);
    }).toList()
      ..sort((a, b) => b.reminderDate!.compareTo(a.reminderDate!));
  }

  Future<int> getNotificationCount() async {
    final overdue = await getOverdueReminders();
    final upcoming = await getUpcomingReminders();
    return overdue.length + upcoming.length;
  }

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  String getTimeUntil(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.inDays > 0) {
      return 'dalam ${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return 'dalam ${difference.inHours} jam';
    } else if (difference.inMinutes > 0) {
      return 'dalam ${difference.inMinutes} menit';
    } else {
      return 'Sebentar lagi';
    }
  }
}
