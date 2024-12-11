import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _navigateToContacts() {
    // Logic to navigate to the contact list
    print('Navigating to contact list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.contacts),
                    onPressed: _navigateToContacts,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_firstNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }

              try {
                String imageUrl = 'default_avatar.jpeg'; // Default image
                if (_firstNameController.text.toLowerCase() == 'ahmed') {
                  imageUrl = 'ahmed.jpeg';
                } else if (_firstNameController.text.toLowerCase() == 'nour') {
                  imageUrl = 'nour.jpeg';
                } else if (_firstNameController.text.toLowerCase() ==
                    'hassan') {
                  imageUrl = 'hassan.jpeg';
                } else if (_firstNameController.text.toLowerCase() == 'sara') {
                  imageUrl = 'sara.jpeg';
                } else if (_firstNameController.text.toLowerCase() ==
                    'mahmoud') {
                  imageUrl = 'mahmoud.jpeg';
                } else if (_firstNameController.text.toLowerCase() == 'tarek') {
                  imageUrl = 'tarek.jpeg';
                }
                await _firestoreService.addFriend(
                    _firstNameController.text, imageUrl);

                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding friend: $e')),
                );
              }
            },
            child: const Text('Add Friend'),
          ),
        ),
      ),
    );
  }
}
