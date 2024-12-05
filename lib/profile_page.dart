import 'package:flutter/material.dart';
import 'database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _birthDate = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final users = await DatabaseHelper().getUsers();
    if (users.isNotEmpty) {
      setState(() {
        _email = users[0]['email'];
        _firstName = users[0]['firstName'];
        _lastName = users[0]['lastName'];
        _birthDate = users[0]['birthDate'];
      });
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
                    controller: TextEditingController(text: _email),
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: false,
                  ),
                  TextField(
                    controller: TextEditingController(text: _firstName),
                    decoration: const InputDecoration(labelText: 'First Name'),
                    enabled: false,
                  ),
                  TextField(
                    controller: TextEditingController(text: _lastName),
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    enabled: false,
                  ),
                  TextField(
                    controller: TextEditingController(text: _birthDate),
                    decoration: const InputDecoration(labelText: 'Birth Date'),
                    enabled: false,
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
