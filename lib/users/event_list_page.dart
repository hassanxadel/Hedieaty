import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class EventListPage extends StatefulWidget {
  final String friendId;

  const EventListPage({super.key, required this.friendId});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> events = [];

  void _sortEvents(String criteria) {
    setState(() {
      events.sort(
          (a, b) => a[criteria].toString().compareTo(b[criteria].toString()));
    });
  }

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
        title: const Text('Events'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortEvents,
            itemBuilder: (BuildContext context) {
              return {'name', 'category', 'status'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Sort by $choice'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.8),
                    AppTheme.secondaryColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/gifts',
                      arguments: {
                        'friendId': widget.friendId,
                        'eventId': events[index]['id'],
                      },
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          events[index]['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          events[index]['category'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
