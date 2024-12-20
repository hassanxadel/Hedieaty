import 'package:flutter/material.dart';
import '../local database/database_helper.dart';

class EditEventDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  const EditEventDetailsPage({super.key, this.eventData});

  @override
  _EditEventDetailsPageState createState() => _EditEventDetailsPageState();
}

class _EditEventDetailsPageState extends State<EditEventDetailsPage> {
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event updated successfully')),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEventDetails,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
