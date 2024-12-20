import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../local database/database_helper.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all friends
  Stream<List<Map<String, dynamic>>> getFriends() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('friends')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> friends = [];
      for (var doc in snapshot.docs) {
        // Get events count for each friend
        final eventsSnapshot = await _db
            .collection('friends')
            .doc(doc.id)
            .collection('events')
            .get();

        final data = doc.data();
        friends.add({
          'id': doc.id,
          'name': data['name'] ?? '',
          'image': data['image'] ?? '',
          'eventsCount': eventsSnapshot.docs.length, // Add events count
        });
      }
      return friends;
    });
  }

  // Add a friend
  Future<void> addFriend(Map<String, dynamic> friendData) async {
    try {
      await _db.collection('friends').add({
        'name': friendData['name'],
        'email': friendData['email'],
        'imageUrl': friendData['imageUrl'],
        'timestamp': friendData['timestamp'],
        'phone': friendData['phone'] ?? '',
      });
    } catch (e) {
      print('Error adding friend: $e');
      throw Exception('Failed to add friend');
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

  Future<Map<String, dynamic>?> getFriendByEmail(String email) async {
    final querySnapshot = await _db
        .collection('friends')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }

  Future<DocumentReference> addFriendWithRef(
      Map<String, dynamic> friendData) async {
    try {
      return await _db.collection('friends').add({
        'name': friendData['name'],
        'email': friendData['email'],
        'imageUrl': friendData['imageUrl'],
        'timestamp': friendData['timestamp'],
        'phone': friendData['phone'] ?? '',
      });
    } catch (e) {
      print('Error adding friend: $e');
      throw Exception('Failed to add friend');
    }
  }

  Future<void> initializeFirestoreData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final dbHelper = DatabaseHelper();
      final events = await dbHelper.getEvents();

      // Batch write to Firestore
      final batch = _db.batch();

      for (var event in events) {
        final eventRef = _db
            .collection('users')
            .doc(user.uid)
            .collection('events')
            .doc(event['id'].toString());

        batch.set(
            eventRef,
            {
              'name': event['name'],
              'category': event['category'],
              'status': event['status'],
              'createdAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));
      }

      await batch.commit();
    } catch (e) {
      print('Error initializing Firestore data: $e');
    }
  }

  static Future<void> initialize() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final instance = FirestoreService();
        final userDoc =
            await instance._db.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await instance.initializeFirestoreData();
        }
      }
    } catch (e) {
      print('Firestore initialization error: $e');
      rethrow;
    }
  }

  Future<void> initializeFirestore() async {
    try {
      // Test connection with a simple query
      await _db.collection('friends').limit(1).get();
    } catch (e) {
      print('Firestore initialization error: $e');
      throw Exception('Failed to initialize Firestore');
    }
  }

  Stream<List<Map<String, dynamic>>> getMyPledgedGifts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('mypledgedgifts')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> gifts = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Fetch original gift data
        final giftDoc = await _db
            .collection('friends')
            .doc(data['friendId'])
            .collection('events')
            .doc(data['eventId'])
            .collection('gifts')
            .doc(data['originalGiftId'])
            .get();

        final giftData = giftDoc.data() ?? {};
        gifts.add({
          'id': doc.id,
          'name': data['name'] ?? '',
          'friend': data['friend'] ?? '',
          'dueDate': data['dueDate'] ?? '',
          'status': data['status'] ?? 'Pending',
          'friendId': data['friendId'],
          'eventId': data['eventId'],
          'originalGiftId': data['originalGiftId'],
          'originalFriend': giftData['friend'] ?? '',
          'originalDueDate': giftData['dueDate'] ?? '',
        });
      }
      return gifts;
    });
  }

  Future<void> addPledgedGift(Map<String, dynamic> giftData, String friendId,
      String eventId, String originalGiftId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('mypledgedgifts').add({
      ...giftData,
      'userId': user.uid,
      'status': 'Pending',
      'pledgedAt': DateTime.now(),
      'friendId': friendId,
      'eventId': eventId,
      'originalGiftId': originalGiftId,
    });
  }

  Future<void> updatePledgedGiftStatus(String giftId, String newStatus) async {
    await _db.collection('mypledgedgifts').doc(giftId).update({
      'status': newStatus,
    });
  }

  Future<void> updateGiftStatus(
      String friendId, String eventId, String giftId, String status) async {
    await _db
        .collection('friends')
        .doc(friendId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .update({'status': status});
  }

  Future<void> deletePledgedGift(String giftId, String friendId, String eventId,
      String originalGiftId) async {
    // Delete from pledged gifts collection
    await _db.collection('mypledgedgifts').doc(giftId).delete();

    // Update original gift status back to Available
    await _db
        .collection('friends')
        .doc(friendId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(originalGiftId)
        .update({'status': 'Available'});
  }

  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    final snapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  Future<void> createUserProfile(
      String email, String firstName, String lastName, String birthDate,
      {File? profileImage}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String imageUrl = 'assets/images/default_avatar.jpeg';

    if (profileImage != null) {
      final fileName = '${user.uid}_profile.jpg';
      imageUrl = await uploadImage(profileImage, fileName);
    }

    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'profileImage': imageUrl
    });
  }
}
