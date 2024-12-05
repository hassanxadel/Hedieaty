import 'package:flutter/material.dart';
import 'database_helper.dart';

class MyGiftListPage extends StatefulWidget {
  const MyGiftListPage({super.key});

  @override
  _MyGiftListPageState createState() => _MyGiftListPageState();
}

class _MyGiftListPageState extends State<MyGiftListPage> {
  List<Map<String, dynamic>> myGifts = [];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  Future<void> _fetchGifts() async {
    final giftList = await DatabaseHelper().getGifts();
    setState(() {
      myGifts = giftList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gifts'),
      ),
      body: ListView.builder(
        itemCount: myGifts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(myGifts[index]['name']),
            subtitle: Text(myGifts[index]['category']),
          );
        },
      ),
    );
  }
}
