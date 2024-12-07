import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class EventListPage extends StatefulWidget {
  final String friendId;

  const EventListPage({super.key, required this.friendId});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _setupEventsListener();
  }

  void _setupEventsListener() {
    _firestoreService.getFriendEvents(widget.friendId).listen((eventList) {
      setState(() {
        events = eventList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/gifts',
                  arguments: {
                    'friendId': widget.friendId,
                    'eventId': events[index]['id'],
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    events[index]['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${events[index]['category']} - ${events[index]['status']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
