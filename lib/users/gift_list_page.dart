import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GiftListPage extends StatefulWidget {
  final String friendId;
  final String eventId;

  const GiftListPage(
      {super.key, required this.friendId, required this.eventId});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> gifts = [];

  @override
  void initState() {
    super.initState();
    _setupGiftsListener(widget.friendId, widget.eventId);
  }

  void _setupGiftsListener(String friendId, String eventId) {
    _firestoreService.getEventGifts(friendId, eventId).listen((giftList) {
      setState(() {
        gifts = giftList;
      });
    });
  }

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
