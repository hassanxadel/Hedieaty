import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../firebase_options.dart';
import '../local database/database_helper.dart';
import 'firestore_service.dart';

class InitializationService {
  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );

    await _initializeDatabase();
    await _initializeFirestore();
  }

  static Future<void> _initializeDatabase() async {
    bool dbInitialized = false;
    int retryCount = 0;

    while (!dbInitialized && retryCount < 3) {
      try {
        await DatabaseHelper.initialize();
        dbInitialized = true;
      } catch (e) {
        retryCount++;
        print('Database initialization attempt $retryCount failed: $e');
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (!dbInitialized) {
      throw Exception('Failed to initialize database after 3 attempts');
    }
  }

  static Future<void> _initializeFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool firestoreInitialized = false;
      int retryCount = 0;

      while (!firestoreInitialized && retryCount < 3) {
        try {
          await FirestoreService.initialize();
          firestoreInitialized = true;
        } catch (e) {
          retryCount++;
          print('Firestore initialization attempt $retryCount failed: $e');
          // Exponential backoff
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }

      if (!firestoreInitialized) {
        throw Exception('Failed to initialize Firestore after 3 attempts');
      }
    }
  }
}
