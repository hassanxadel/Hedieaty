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
        'status': _isPledged ? 'Pledged' : 'Available',
        'eventId': widget.eventId,
        'image': _image != null ? await _image!.readAsBytes() : null,
      };

      await DatabaseHelper().insertGift(gift);
      Navigator.pop(context);
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
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            SwitchListTile(
              title: const Text('Gift Status'),
              subtitle: Text(_isPledged ? 'Pledged' : 'Available'),
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveGiftDetails,
              child: const Text('Save Gift'),
            ),
          ],
        ),
      ),
    );
  }
}
