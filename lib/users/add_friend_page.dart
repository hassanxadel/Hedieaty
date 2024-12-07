import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
      body: Padding(
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
                    controller: _phoneNumberController,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_imageFile != null) {
                final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
                final imageUrl =
                    await _firestoreService.uploadImage(_imageFile!, fileName);
                await _firestoreService.addFriend(
                    _firstNameController.text, imageUrl);
              }
              Navigator.pop(context);
            },
            child: const Text('Add Friend'),
          ),
        ),
      ),
    );
  }
}
