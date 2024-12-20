import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/firestore_service.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  const MyPledgedGiftsPage({super.key});

  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> pledgedGifts = [];

  @override
  void initState() {
    super.initState();
    _setupPledgedGiftsListener();
  }

  void _setupPledgedGiftsListener() {
    print('Setting up pledged gifts listener');
    _firestoreService.getMyPledgedGifts().listen(
      (giftList) {
        print('Received gift list: $giftList');
        setState(() {
          pledgedGifts = giftList;
        });
      },
      onError: (error) {
        print('Error fetching pledged gifts: $error');
      },
    );
  }

  void _toggleStatus(int index) async {
    final gift = pledgedGifts[index];
    final newStatus = gift['status'] == 'Pending' ? 'Completed' : 'Pending';

    await _firestoreService.updatePledgedGiftStatus(gift['id'], newStatus);
  }

  void _sortPledgedGifts(String criteria) {
    setState(() {
      pledgedGifts.sort((a, b) => (a[criteria] ?? '')
          .toString()
          .compareTo((b[criteria] ?? '').toString()));
    });
  }

  void _deletePledgedGift(int index) async {
    final gift = pledgedGifts[index];
    print('Deleting gift: $gift');

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gift'),
        content:
            const Text('Are you sure you want to delete this pledged gift?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      if (gift['friendId'] == null ||
          gift['eventId'] == null ||
          gift['originalGiftId'] == null) {
        throw 'Missing required fields for deletion';
      }

      await _firestoreService.deletePledgedGift(
        gift['id'],
        gift['friendId'],
        gift['eventId'],
        gift['originalGiftId'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift deleted successfully')),
        );
      }
    } catch (e) {
      print('Error deleting gift: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting gift: $e')),
        );
      }
    }
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
          itemCount: pledgedGifts.length,
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pledgedGifts[index]['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Friend: ${pledgedGifts[index]['friend']} (Original: ${pledgedGifts[index]['originalFriend']})',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Due: ${pledgedGifts[index]['dueDate']} (Original: ${pledgedGifts[index]['originalDueDate']})',
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
                          color: pledgedGifts[index]['status'] == 'Completed'
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          pledgedGifts[index]['status'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          pledgedGifts[index]['status'] == 'Pending'
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () => _toggleStatus(index),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () => _deletePledgedGift(index),
                      ),
                    ],
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
