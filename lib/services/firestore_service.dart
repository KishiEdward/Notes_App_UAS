import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> addNote(String title, String content, String category, bool isPinned) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('notes').add({
      'userId': user.uid,
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String id, String title, String content, String category, bool isPinned) async {
    await _db.collection('notes').doc(id).update({
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> togglePin(String id, bool currentStatus) async {
    await _db.collection('notes').doc(id).update({
      'isPinned': !currentStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await _db.collection('notes').doc(id).delete();
  }
}
