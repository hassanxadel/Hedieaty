import 'package:flutter/material.dart';
import '../local database/database_helper.dart';
import '../theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_gift_list_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _notificationsEnabled = false;
  List<Map<String, dynamic>> events = [];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchEvents();
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

  Future<void> _fetchEvents() async {
    final eventList = await DatabaseHelper().getEvents();
    setState(() {
      events = eventList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),
              _buildProfileField(
                  'First Name', _firstNameController, _isEditing),
              _buildProfileField('Last Name', _lastNameController, _isEditing),
              _buildProfileField('Email', _emailController, _isEditing),
              _buildProfileField(
                  'Birth Date', _birthDateController, _isEditing),
              const SizedBox(height: 16),
              _buildSettingsSection(),
              _buildNavigationButtons(context),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/loginSignup');
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
      String label, TextEditingController controller, bool isEditing) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
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
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Container(
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

          const SizedBox(height: 16.0),
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
            itemCount: events.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(events[index]['name']),
                subtitle: Text(
                    '${events[index]['category']} - ${events[index]['status']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyGiftListPage(
                        eventId: events[index]['id'],
                      ),
                    ),
                  );
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
    );
  }
}
