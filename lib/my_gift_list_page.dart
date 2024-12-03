import 'package:flutter/material.dart';

class MyGiftListPage extends StatefulWidget {
  const MyGiftListPage({super.key});

  @override
  _MyGiftListPageState createState() => _MyGiftListPageState();
}

class _MyGiftListPageState extends State<MyGiftListPage> {
  List<Map<String, dynamic>> mygifts = [
    {'name': 'Smart Watch', 'category': 'Electronics', 'status': 'Available'},
    {'name': 'Book Set', 'category': 'Books', 'status': 'Pledged'},
    {'name': 'Card Holder', 'category': 'Wallets', 'status': 'Pledged'},
    {'name': 'Air Force one', 'category': 'Shoes', 'status': 'Available'},
    {'name': 'TV', 'category': 'Electronics', 'status': 'Available'},
    {'name': 'Phone Case', 'category': 'Accessories', 'status': 'Pledged'},
  ];

  void _sortGifts(String criteria) {
    setState(() {
      mygifts.sort((a, b) => a[criteria].compareTo(b[criteria]));
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
        itemCount: mygifts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mygifts[index]['name']),
            subtitle:
                Text('${mygifts[index]['category']} - ${mygifts[index]['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(context, '/editMyGifts');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      mygifts.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            tileColor:
                mygifts[index]['status'] == 'Pledged' ? Colors.grey[300] : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/giftDetails');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
