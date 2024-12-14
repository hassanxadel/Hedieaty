import 'package:flutter/material.dart';
import '../local database/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GiftDetailsPage extends StatefulWidget {
  final int eventId;
  const GiftDetailsPage({super.key, required this.eventId});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPledged = false;
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

  Future<void> _saveGiftDetails() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty) {
      final gift = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'status': _isPledged ? 'Pledged' : 'Available',
        'eventId': widget.eventId,
        'image': _image != null ? await _image!.readAsBytes() : null,
      };

      await DatabaseHelper().insertGift(gift);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      // Show error message if required fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Gift')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name*',
                hintText: 'Enter gift name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category*',
                hintText: 'Enter gift category',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter gift description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Pledged'),
              value: _isPledged,
              onChanged: (bool value) {
                setState(() {
                  _isPledged = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _image == null
                ? ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Add Image'),
                  )
                : Column(
                    children: [
                      Image.file(_image!, height: 200),
                      TextButton(
                        onPressed: _pickImage,
                        child: const Text('Change Image'),
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGiftDetails,
                child: const Text('Save Gift'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
