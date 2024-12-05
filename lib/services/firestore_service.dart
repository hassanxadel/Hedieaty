import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add an event
  Future<void> addEvent(
      String name, String category, String status, DateTime? date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('my_events').add({
        'name': name,
        'category': category,
        'status': status,
        'date': date?.toIso8601String(),
        'userId':
            user.uid, // Optional: if you want to associate events with users
      });
    }
  }

  // Update an event
  Future<void> updateEvent(String id, String name, String category,
      String status, DateTime? date) async {
    await _db.collection('my_events').doc(id).update({
      'name': name,
      'category': category,
      'status': status,
      'date': date?.toIso8601String(),
    });
  }

  // Get user events
  Stream<List<Map<String, dynamic>>> getUserEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _db
          .collection('my_events')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
    }
    return Stream.empty();
  }

  // Delete an event
  Future<void> deleteEvent(String id) async {
    await _db.collection('my_events').doc(id).delete();
  }
}
