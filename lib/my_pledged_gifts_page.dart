import 'package:flutter/material.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  const MyPledgedGiftsPage({super.key});

  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  List<Map<String, dynamic>> pledgedGifts = [
    {
      'name': 'Smart Watch',
      'friend': 'Ahmed',
      'dueDate': '2024-12-05',
      'status': 'Pending'
    },
    {
      'name': 'Book Set',
      'friend': 'Khaled',
      'dueDate': '2024-12-15',
      'status': 'Completed'
    },
    {
      'name': 'Iphone',
      'friend': 'Sara',
      'dueDate': '2024-12-20',
      'status': 'Pending'
    },
    {
      'name': 'Labtop',
      'friend': 'Fatma',
      'dueDate': '2024-12-30',
      'status': 'Completed'
    },
  ];

  void _editPledge(int index) {
    // Placeholder for editing a pledge
    print('Edit pledge at index $index');
  }

  void _sortPledgedGifts(String criteria) {
    setState(() {
      pledgedGifts.sort((a, b) => a[criteria].compareTo(b[criteria]));
    });
  }

  void _toggleStatus(int index) {
    setState(() {
      if (pledgedGifts[index]['status'] == 'Pending') {
        pledgedGifts[index]['status'] = 'Completed';
      } else {
        pledgedGifts[index]['status'] = 'Pending';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pledged Gifts'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortPledgedGifts,
            itemBuilder: (BuildContext context) {
              return {'status', 'dueDate'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text('Sort by $choice'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pledgedGifts[index]['name']),
            subtitle: Text(
                'Friend: ${pledgedGifts[index]['friend']} - Due: ${pledgedGifts[index]['dueDate']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    if (pledgedGifts[index]['status'] == 'Pending') {
                      _toggleStatus(index);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (pledgedGifts[index]['status'] == 'Completed') {
                      _toggleStatus(index);
                    }
                  },
                ),
              ],
            ),
            tileColor: pledgedGifts[index]['status'] == 'Pending'
                ? Colors.yellow[100]
                : Colors.green[100],
          );
        },
      ),
    );
  }
}
