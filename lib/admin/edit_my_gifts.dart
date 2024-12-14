import 'package:flutter/material.dart';
import '../local database/database_helper.dart';

class EditGiftDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? giftData;

  const EditGiftDetailsPage({super.key, this.giftData});

  @override
  _editGiftDetailsPageState createState() => _editGiftDetailsPageState();
}

class _editGiftDetailsPageState extends State<EditGiftDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? giftId;

  @override
  void initState() {
    super.initState();
    if (widget.giftData != null) {
      _nameController.text = widget.giftData!['name'];
      _categoryController.text = widget.giftData!['category'];
      _statusController.text = widget.giftData!['status'];
      _descriptionController.text = widget.giftData!['description'] ?? '';
      giftId = widget.giftData!['id'];
    }
  }

  Future<void> _saveGiftDetails() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      final gift = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'status': _statusController.text,
        'description': _descriptionController.text,
        'eventId': widget.giftData!['eventId'],
        'image': widget.giftData!['image'],
      };

      if (giftId != null) {
        await DatabaseHelper().updateGift(giftId!, gift);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Gift Details'),
      ),
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
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _saveGiftDetails,
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
