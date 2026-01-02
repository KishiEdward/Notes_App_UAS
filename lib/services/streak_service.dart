import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getCurrentStreak() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return 0;

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['streak'] ?? 0;
    } catch (e) {
      print('Error getting streak: $e');
      return 0;
    }
  }

  Future<void> updateStreak() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data() ?? {};
      
      final lastNoteDate = data['lastNoteDate'] as Timestamp?;
      final currentStreak = data['streak'] ?? 0;
      
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      if (lastNoteDate == null) {
        await _firestore.collection('users').doc(userId).update({
          'streak': 1,
          'lastNoteDate': Timestamp.fromDate(today),
        });
        return;
      }
      
      final lastDate = lastNoteDate.toDate();
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final difference = today.difference(lastDay).inDays;
      
      if (difference == 0) {
        return;
      } else if (difference == 1) {
        await _firestore.collection('users').doc(userId).update({
          'streak': currentStreak + 1,
          'lastNoteDate': Timestamp.fromDate(today),
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'streak': 1,
          'lastNoteDate': Timestamp.fromDate(today),
        });
      }
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  Future<bool> hasCreatedNoteToday() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final lastNoteDate = userDoc.data()?['lastNoteDate'] as Timestamp?;
      
      if (lastNoteDate == null) return false;
      
      final lastDate = lastNoteDate.toDate();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      
      return today == lastDay;
    } catch (e) {
      print('Error checking note today: $e');
      return false;
    }
  }
}
