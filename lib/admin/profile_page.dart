import 'package:flutter/material.dart';
import '../local database/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  String _gender = 'Male';
  bool _notificationsEnabled = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final users = await DatabaseHelper().getUsers();
    print('Fetched Users: $users'); // Debugging purpose
    if (users.isNotEmpty) {
      setState(() {
        _emailController.text = users[0]['email'] ?? '';
        _firstNameController.text = users[0]['firstName'] ?? '';
        _lastNameController.text = users[0]['lastName'] ?? '';
        _birthDateController.text = users[0]['birthDate'] ?? '';
      });
    } else {
      print('No user data found in local database.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // My Info Section
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Account info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpeg'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: _isEditing,
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    enabled: _isEditing,
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    enabled: _isEditing,
                  ),
                  TextField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(labelText: 'Birth Date'),
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text('Gender:'),
                      Radio<String>(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              }
                            : null,
                      ),
                      const Text('Male'),
                      Radio<String>(
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              }
                            : null,
                      ),
                      const Text('Female'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(_isEditing ? 'Save' : 'Edit'),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Settings Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Notification'),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/pledgedGifts');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Pledged Gifts List'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // My List of Events Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/myEvents');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My List of Events'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        3, // Assuming 3 events as in event_list_page.dart
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Event ${index + 1}'),
                        subtitle: const Text('Category - Status'),
                        onTap: () {
                          Navigator.pushNamed(context, '/myGifts');
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/createEventList');
                        },
                        child: const Text('Add Your Own Event'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
