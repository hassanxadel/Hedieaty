import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../local database/database_helper.dart';
import '../admin/my_gift_list_page.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  List<Map<String, dynamic>> events = [];

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
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/createEventList');
              _fetchEvents(); // Refresh after returning
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
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(events[index]['name']),
                subtitle: Text(
                    '${events[index]['category']} - ${events[index]['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          '/editEvents',
                          arguments: events[index],
                        );
                        _fetchEvents(); // Refresh after editing
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEvent(events[index]['id']),
                    ),
                  ],
                ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
