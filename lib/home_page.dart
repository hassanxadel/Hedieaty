import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> friends = [
    {'name': 'Hassan', 'events': 2, 'image': 'ahmed.jpeg'},
    {'name': 'Fatma', 'events': 4, 'image': 'sara.jpeg'},
    {'name': 'Mohamed', 'events': 1, 'image': 'mohamed.jpeg'},
    {'name': 'Khaled', 'events': 3, 'image': 'khaled.jpeg'},
    {'name': 'Omar', 'events': 2, 'image': 'omar.jpeg'},
    {'name': 'Ramy', 'events': 3, 'image': 'ramy.jpeg'},
    {'name': 'Youssef', 'events': 1, 'image': 'youssef.jpeg'},
    {'name': 'Nour', 'events': 4, 'image': 'nour.jpeg'},
  ];

  // Search controller
  TextEditingController searchController = TextEditingController();

  // Filtered list of friends
  List<Map<String, dynamic>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = friends; // Initially, all friends are shown
    searchController.addListener(() {
      filterFriends();
    });
  }

  void filterFriends() {
    List<Map<String, dynamic>> results = [];
    if (searchController.text.isEmpty) {
      results = friends;
    } else {
      results = friends
          .where((friend) => friend['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredFriends = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hedieaty Home'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addFriend');
                  }
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // Wrap in a Row to allow multiple children
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      filterFriends();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two squares per row
                childAspectRatio: 1, // Make each item a square
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/events',
                        arguments: filteredFriends[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                              'assets/images/${filteredFriends[index]['image']}'),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          filteredFriends[index]['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          filteredFriends[index]['events'] > 0
                              ? 'Events: ${filteredFriends[index]['events']}'
                              : 'No Events',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/myEvents');
                },
                child: const Text('Add Your Own Event/List'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
