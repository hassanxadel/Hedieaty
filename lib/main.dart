import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'theme/app_theme.dart';
import 'login_signup_page.dart';
import 'home_page.dart';
import 'admin/create_event_list_page.dart';
import 'admin/profile_page.dart';
import 'admin/my_pledged_gifts_page.dart';
import 'admin/my_events_page.dart';
import 'users/event_list_page.dart';
import 'users/gift_list_page.dart';
import 'users/add_friend_page.dart';
import 'admin/edit_my_gifts.dart';
import 'theme/page_transitions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await InitializationService.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print('Critical initialization error: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: AppTheme.lightTheme,
      home: const LoginSignupPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginSignupPage(),
        '/profile': (context) => const ProfilePage(),
        '/pledgedGifts': (context) => const MyPledgedGiftsPage(),
        '/myEvents': (context) => const MyEventsPage(),
        '/createEventList': (context) => const CreateEventListPage(),
        '/addfriend': (context) => const AddFriendPage(),
        '/editmygifts': (context) => const EditGiftDetailsPage(),
        '/gifts': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          return GiftListPage(
            eventId: args['eventId'],
            friendId: args['friendId'],
          );
        },
        '/events': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          return EventListPage(friendId: args['friendId']);
        },
      },
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/home':
            page = const HomePage();
            break;
          case '/profile':
            page = const ProfilePage();
            break;
          // ... other routes ...
          default:
            page = const LoginSignupPage();
        }
        return SlidePageRoute(page: page);
      },
    );
  }
}
