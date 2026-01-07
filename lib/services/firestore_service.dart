import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/models/note_model.dart';
import 'package:notesapp/services/streak_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreakService _streakService = StreakService();

  Stream<List<Note>> getNotesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _db
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs.map((doc) {
            return Note.fromMap(doc.data(), doc.id);
          }).toList();

          notes.sort((a, b) {
            if (a.isPinned != b.isPinned) {
              return a.isPinned ? -1 : 1;
            }
            return b.updatedAt.compareTo(a.updatedAt);
          });
          return notes;
        });
  }

  Stream<List<Note>> getArchivedNotesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _db
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .where('isArchived', isEqualTo: true)
        .where('isTrashed', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          final notes = snapshot.docs.map((doc) {
            return Note.fromMap(doc.data(), doc.id);
          }).toList();

          notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return notes;
        });
  }

  Future<void> addNote(
    String title,
    String content,
    String category,
    bool isPinned,
    DateTime? reminderDate,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('notes').add({
      'userId': user.uid,
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'isTrashed': false,
      'isArchived': false,
      'trashedAt': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'reminderDate': reminderDate,
    });

    await _streakService.updateStreak();
  }

  Future<void> updateNote(
    String id,
    String title,
    String content,
    String category,
    bool isPinned,
    DateTime? reminderDate,
  ) async {
    await _db.collection('notes').doc(id).update({
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'updatedAt': FieldValue.serverTimestamp(),
      'reminderDate': reminderDate,
    });
  }

  Future<void> togglePin(String id, bool currentStatus) async {
    await _db.collection('notes').doc(id).update({
      'isPinned': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleArchive(String id, bool currentStatus) async {
    await _db.collection('notes').doc(id).update({
      'isArchived': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> moveToTrash(String id) async {
    await _db.collection('notes').doc(id).update({
      'isTrashed': true,
      'isPinned': false,
      'trashedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restoreFromTrash(String id) async {
    await _db.collection('notes').doc(id).update({
      'isTrashed': false,
      'trashedAt': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }

  Future<int> cleanupOldTrashedNotes() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final snapshot = await _db
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .where('isTrashed', isEqualTo: true)
        .get();

    int deletedCount = 0;
    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      if (data['trashedAt'] != null) {
        final Timestamp timestamp = data['trashedAt'];
        final DateTime trashedAt = timestamp.toDate();

        final difference = now.difference(trashedAt).inDays;

        if (difference >= 7) {
          await doc.reference.delete();
          deletedCount++;
        }
      }
    }
    return deletedCount;
  }
}
