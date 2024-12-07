import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateEventListPage extends StatefulWidget {
  const CreateEventListPage({super.key});

  @override
  _CreateEventListPageState createState() => _CreateEventListPageState();
}

class _CreateEventListPageState extends State<CreateEventListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveEventDetails() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _statusController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('my_events').add({
        'name': _nameController.text,
        'category': _categoryController.text,
        'status': _statusController.text,
        'date': _selectedDate?.toIso8601String(),
      });
      Navigator.pop(context); // Go back after saving
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected!'
                      : 'Selected Date: ${_selectedDate!.toLocal()}'
                          .split(' ')[0],
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _saveEventDetails,
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
