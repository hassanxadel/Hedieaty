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

  void _sortGifts(String criteria) {
    setState(() {
      List<Map<String, dynamic>> sortedGifts = List.from(myGifts);
      sortedGifts.sort((a, b) => (a[criteria]?.toString() ?? '')
          .compareTo(b[criteria]?.toString() ?? ''));
      myGifts = sortedGifts;
    });
  }

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
          padding: const EdgeInsets.all(16),
          itemCount: myGifts.length,
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
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDetailsViewPage(
                          gift: myGifts[index],
                        ),
                      ),
                    );
                    _fetchGifts();
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
                                myGifts[index]['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${myGifts[index]['category']} - ${myGifts[index]['status']}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (myGifts[index]['status'] != 'Pledged')
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
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
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () =>
                                    _deleteGift(myGifts[index]['id']),
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
