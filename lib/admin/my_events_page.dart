import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../local database/database_helper.dart';
import 'my_gift_list_page.dart';
import 'edit_event_list.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<Map<String, dynamic>> events = [];

  void _sortEvents(String criteria) {
    setState(() {
      List<Map<String, dynamic>> sortedEvents = List.from(events);
      sortedEvents.sort((a, b) => (a[criteria]?.toString() ?? '')
          .compareTo(b[criteria]?.toString() ?? ''));
      events = sortedEvents;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final eventList = await DatabaseHelper().getEvents();
    setState(() {
      events = eventList;
    });
  }

  Future<void> _deleteEvent(int id) async {
    await DatabaseHelper().deleteEvent(id);
    _fetchEvents(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/createEventList');
              _fetchEvents();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyGiftListPage(
                          eventId: events[index]['id'],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
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
                              Text(
                                '${events[index]['category']} - ${events[index]['status']}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditEventDetailsPage(
                                      eventData: events[index],
                                    ),
                                  ),
                                );
                                _fetchEvents();
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () =>
                                  _deleteEvent(events[index]['id']),
                            ),
                          ],
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
