import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all friends
  Stream<List<Map<String, dynamic>>> getFriends() {
    return _db
        .collection('friends')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // Add a friend
  Future<void> addFriend(String name, String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('friends').add({
        'name': name,
        'events': 0,
        'image': imageUrl,
        'addedBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Add this method to upload image and get URL
  Future<String> uploadImage(File imageFile, String fileName) async {
    try {
      // Create a reference to the file location
      final Reference ref = _storage.ref().child('friend_images/$fileName');

      // Upload the file
      final UploadTask uploadTask = ref.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  // Add event to a friend
  Future<void> addFriendEvent(
      String friendId, String name, String category, String status) async {
    await _db.collection('friends').doc(friendId).collection('events').add({
      'name': name,
      'category': category,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get friend's events
  Stream<List<Map<String, dynamic>>> getFriendEvents(String friendId) {
    return _db
        .collection('friends')
        .doc(friendId)
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  // Add gift to an event
  Future<void> addEventGift(
      String friendId, String eventId, Map<String, dynamic> giftData) async {
    await _db
        .collection('friends')
        .doc(friendId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .add(giftData);
  }

  Stream<List<Map<String, dynamic>>> getEventGifts(
      String friendId, String eventId) {
    return _db
        .collection('friends')
        .doc(friendId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Stream<List<Map<String, dynamic>>> getUserEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _db
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList());
    }
    return const Stream.empty();
  }

  Future<void> deleteEvent(String eventId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(eventId)
          .delete();
    }
  }
}
