import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

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
              return {'name', 'category'}.map((String choice) {
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
        child: gifts.isEmpty
            ? const Center(
                child: Text('No gifts found for this event'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: gifts.length,
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
                        onTap: () => _isPledgedGift(index),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gifts[index]['name'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      gifts[index]['category'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: gifts[index]['status'] == 'Pledged'
                                      ? Colors.green
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  gifts[index]['status'] ?? 'Available',
                                  style: TextStyle(
                                    color: gifts[index]['status'] == 'Pledged'
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
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
