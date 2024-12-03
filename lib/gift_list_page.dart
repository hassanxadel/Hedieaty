import 'package:flutter/material.dart';

class GiftListPage extends StatefulWidget {
  const GiftListPage({super.key});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  List<Map<String, dynamic>> gifts = [
    {'name': 'Smart Watch', 'category': 'Electronics', 'status': 'Available'},
    {'name': 'Book Set', 'category': 'Books', 'status': 'Available'},
  ];

  void _isPledgedGift(int index) {
    setState(() {
      gifts[index]['status'] = 'Pledged';
    });
  }

  void _sortGifts(String criteria) {
    setState(() {
      gifts.sort((a, b) => a[criteria].compareTo(b[criteria]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortGifts,
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
      body: ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(gifts[index]['name']),
            subtitle:
                Text('${gifts[index]['category']} - ${gifts[index]['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => _isPledgedGift(index),
                ),
              ],
            ),
            tileColor: gifts[index]['status'] == 'Pledged'
                ? Colors.lightGreen[100]
                : null,
          );
        },
      ),
    );
  }
}
