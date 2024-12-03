import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'create_event_list_page.dart';
import 'event_list_page.dart';
import 'gift_details_page.dart';
import 'gift_list_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'my_events_page.dart';
import 'my_gift_list_page.dart';
import 'my_pledged_gifts_page.dart';
import 'profile_page.dart';
import 'add_friend_page.dart';
import 'edit_my_gifts.dart';
import 'edit_event_list.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Hedieaty',
    initialRoute: '/login',
    routes: {
      '/createEventList': (context) => const CreateEventListPage(),
      '/events': (context) => const EventListPage(),
      '/giftDetails': (context) => const GiftDetailsPage(),
      '/gifts': (context) => const GiftListPage(),
      '/home': (context) => const HomePage(),
      '/login': (context) => const LoginPage(),
      '/myEvents': (context) => const MyEventsPage(),
      '/myGifts': (context) => const MyGiftListPage(),
      '/pledgedGifts': (context) => const MyPledgedGiftsPage(),
      '/profile': (context) => const ProfilePage(),
      '/addFriend': (context) => const AddFriendPage(),
      '/editMyGifts': (context) => const EditGiftDetailsPage(),
      '/editEvents': (context) => const EditEventDetailsPage(),
      '/signup': (context) => const SignupPage(),
    },
  ));
}
