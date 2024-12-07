import 'package:flutter/material.dart';

class EditEventDetailsPage extends StatefulWidget {
  const EditEventDetailsPage({super.key});

  @override
  _editEventDetailsPageState createState() => _editEventDetailsPageState();
}

class _editEventDetailsPageState extends State<EditEventDetailsPage> {
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

  void _saveEventDetails() {
    // Placeholder for saving gift details
    print('Save Event details');
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
              child: const Text('Edit'),
            )
          ],
        ),
      ),
    );
  }
}
