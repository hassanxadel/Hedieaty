import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    String fileName = path.basename(imageFile.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('friend_images/$fileName');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(75),
                    border: Border.all(color: AppTheme.primaryColor),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: AppTheme.primaryColor,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_firstNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a first name')),
              );
              return;
            }

            try {
              String imageUrl = 'assets/images/default_avatar.jpeg';
              if (_image != null) {
                imageUrl = await _uploadImage(_image!);
              }

              await _firestoreService.addFriend({
                'name':
                    '${_firstNameController.text} ${_lastNameController.text}'
                        .trim(),
                'phone': _phoneController.text,
                'imageUrl': imageUrl,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
              });

              if (mounted) Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding friend: $e')),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Add Friend',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
