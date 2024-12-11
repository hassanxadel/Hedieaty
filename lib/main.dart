import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'admin/create_event_list_page.dart';
import 'users/event_list_page.dart';
import 'admin/gift_details_page.dart';
import 'users/gift_list_page.dart';
import 'home_page.dart';
import 'login_signup_page.dart';
import 'admin/my_events_page.dart';
import 'admin/my_gift_list_page.dart';
import 'admin/my_pledged_gifts_page.dart';
import 'admin/profile_page.dart';
import 'users/add_friend_page.dart';
import 'admin/edit_my_gifts.dart';
import 'admin/edit_event_list.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'local database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dbHelper = DatabaseHelper();
  await dbHelper.initializeSampleData();

  runApp(MaterialApp(
    title: 'Hedieaty',
    theme: AppTheme.lightTheme,
    initialRoute: '/loginSignup',
    onGenerateRoute: (settings) {
      if (settings.name == '/events') {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => EventListPage(friendId: args['friendId']),
        );
      } else if (settings.name == '/gifts') {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => GiftListPage(
            friendId: args['friendId'],
            eventId: args['eventId'],
          ),
        );
      } else if (settings.name == '/editEvents') {
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => EditEventDetailsPage(eventData: args),
        );
      } else if (settings.name == '/editMyGifts') {
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => EditGiftDetailsPage(giftData: args),
        );
      } else if (settings.name == '/myGifts') {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => MyGiftListPage(eventId: args['eventId']),
        );
      } else if (settings.name == '/giftDetails') {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => GiftDetailsPage(eventId: args['eventId']),
        );
      }

      return null;
    },
    routes: {
      '/loginSignup': (context) => const LoginSignupPage(),
      '/home': (context) => const HomePage(),
      '/profile': (context) => const ProfilePage(),
      '/createEventList': (context) => const CreateEventListPage(),
      '/myEvents': (context) => const MyEventsPage(),
      '/pledgedGifts': (context) => const MyPledgedGiftsPage(),
      '/addFriend': (context) => const AddFriendPage(),
    },
  ));
}
