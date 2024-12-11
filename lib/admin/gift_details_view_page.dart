import 'package:flutter/material.dart';
import 'dart:typed_data';

class GiftDetailsViewPage extends StatefulWidget {
  final Map<String, dynamic> gift;

  const GiftDetailsViewPage({super.key, required this.gift});

  @override
  State<GiftDetailsViewPage> createState() => _GiftDetailsViewPageState();
}

class _GiftDetailsViewPageState extends State<GiftDetailsViewPage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.gift['image'] != null) {
      imageBytes = widget.gift['image'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageBytes != null)
              Image.memory(
                imageBytes!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              'Name: ${widget.gift['name']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${widget.gift['category']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${widget.gift['description'] ?? 'No description available'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Status'),
              subtitle: Text(widget.gift['status']),
              value: widget.gift['status'] == 'Pledged',
              onChanged: null, // Disabled, read-only
            ),
          ],
        ),
      ),
    );
  }
}
