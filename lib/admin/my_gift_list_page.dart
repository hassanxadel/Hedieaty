import 'package:flutter/material.dart';
import '../local database/database_helper.dart';
import '../theme/app_theme.dart';
import 'gift_details_page.dart';
import 'gift_details_view_page.dart';

class MyGiftListPage extends StatefulWidget {
  final int eventId;
  const MyGiftListPage({super.key, required this.eventId});

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
    final giftList = await DatabaseHelper().getGiftsByEventId(widget.eventId);
    setState(() {
      myGifts = giftList;
    });
  }

  Future<void> _deleteGift(int id) async {
    await DatabaseHelper().deleteGift(id);
    _fetchGifts(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gifts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GiftDetailsPage(eventId: widget.eventId),
                ),
              );
              _fetchGifts();
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
          itemCount: myGifts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(myGifts[index]['name']),
                subtitle: Text(
                    '${myGifts[index]['category']} - ${myGifts[index]['status']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiftDetailsViewPage(
                        gift: myGifts[index],
                      ),
                    ),
                  );
                },
                trailing: myGifts[index]['status'] != 'Pledged'
                    ? SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/editMyGifts',
                                  arguments: myGifts[index],
                                );
                                _fetchGifts();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteGift(myGifts[index]['id']),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
