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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      }

      return null;
    },
    routes: {
      '/loginSignup': (context) => const LoginSignupPage(),
      '/home': (context) => const HomePage(),
      '/profile': (context) => const ProfilePage(),
      '/createEventList': (context) => const CreateEventListPage(),
      '/giftDetails': (context) => const GiftDetailsPage(),
      '/myEvents': (context) => const MyEventsPage(),
      '/myGifts': (context) => const MyGiftListPage(),
      '/pledgedGifts': (context) => const MyPledgedGiftsPage(),
      '/addFriend': (context) => const AddFriendPage(),
      '/editMyGifts': (context) => const EditGiftDetailsPage(),
      '/editEvents': (context) => const EditEventDetailsPage(),
    },
  ));
}
