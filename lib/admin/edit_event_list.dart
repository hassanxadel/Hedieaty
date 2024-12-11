import 'package:flutter/material.dart';
import '../local database/database_helper.dart';

class EditEventDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const EditEventDetailsPage({super.key, this.eventData});

  @override
  _editEventDetailsPageState createState() => _editEventDetailsPageState();
}

class _editEventDetailsPageState extends State<EditEventDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  int? eventId;

  @override
  void initState() {
    super.initState();
    if (widget.eventData != null) {
      _nameController.text = widget.eventData!['name'];
      _categoryController.text = widget.eventData!['category'];
      _statusController.text = widget.eventData!['status'];
      eventId = widget.eventData!['id'];
    }
  }

  Future<void> _saveEventDetails() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      final event = {
        'name': _nameController.text,
        'category': _categoryController.text,
        'status': _statusController.text,
      };

      if (eventId != null) {
        await DatabaseHelper().updateEvent(eventId!, event);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event Details'),
      ),
      body: SingleChildScrollView(
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
            ElevatedButton(
              onPressed: _saveEventDetails,
              child: const Text('Edit'),
            )
          ],
        ),
      ),
    );
  }
}
