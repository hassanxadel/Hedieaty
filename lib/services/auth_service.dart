import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify user exists in Firestore
      final userDoc =
          await _firestore.collection('users').doc(result.user!.uid).get();
      if (!userDoc.exists) {
        throw Exception('User not found in database');
      }

      // Convert the data to Map<String, dynamic> explicitly
      final userData = userDoc.data() as Map<String, dynamic>;

      // Instead of trying to cast to PigeonUserDetails, just use the Map
      if (!userData.containsKey('first_name') ||
          !userData.containsKey('last_name')) {
        throw Exception('Invalid user data format');
      }

      return result.user;
    } catch (e) {
      print('Sign in error: $e');
      throw Exception(e.toString());
    }
  }

  // Sign Up
  Future<User?> signUp(
      String email, String password, Map<String, String> userDetails) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details in Firestore
      await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .set(userDetails);

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Current User
  User? get currentUser {
    return _auth.currentUser;
  }
}
