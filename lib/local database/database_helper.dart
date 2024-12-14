import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'hedieaty.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, int version) async {
        await createTables(db);
        await initializeSampleData();
        await initializeFriendData();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('DROP TABLE IF EXISTS my_gifts');
        await db.execute('DROP TABLE IF EXISTS my_events');
        await db.execute('DROP TABLE IF EXISTS friend_images');
        await createTables(db);
      },
    );
  }

  // CRUD Operations for Events
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db?.insert('my_events', event) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return await db?.query('my_events') ?? [];
  }

  Future<void> updateEvent(int id, Map<String, dynamic> event) async {
    final db = await database;
    await db?.update('my_events', event, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db?.delete('my_events', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Gifts
  Future<void> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    await db?.insert('my_gifts', gift);
  }

  Future<List<Map<String, dynamic>>> getGifts() async {
    final db = await database;
    return await db?.query('my_gifts') ?? [];
  }

  Future<void> updateGift(int id, Map<String, dynamic> gift) async {
    final db = await database;
    await db?.update('my_gifts', gift, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteGift(int id) async {
    final db = await database;
    await db?.delete('my_gifts', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Users
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db?.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    final users = await db?.query('users') ?? [];
    print('Fetched Users: $users'); // Debugging purpose
    return users;
  }

  // Add method to store friend image
  Future<void> storeFriendImage(String friendName, String imagePath) async {
    final db = await database;
    await db?.insert(
      'friend_images',
      {'friend_name': friendName.toLowerCase(), 'image_path': imagePath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Add method to get friend image
  Future<String?> getFriendImage(String firstName) async {
    switch (firstName.toLowerCase()) {
      case 'hassan':
        return 'assets/images/hassan.jpeg';
      case 'tarek':
        return 'assets/images/tarek.jpeg';
      case 'sara':
        return 'assets/images/sara.jpeg';
      case 'nour':
        return 'assets/images/nour.jpeg';
      case 'mahmoud':
        return 'assets/images/mahmoud.jpeg';
      case 'ahmed':
        return 'assets/images/ahmed.jpeg';
      default:
        return 'assets/images/default_avatar.jpeg';
    }
  }

  Future<void> initializeSampleData() async {
    final db = await database;
    await db?.delete('my_events');
    await db?.delete('my_gifts');
    await db?.delete('users'); // Clear existing users

    // Add sample users with their emails
    await insertUser({
      'email': 'hassanadelh@gmail.com',
      'firstName': 'Hassan',
      'lastName': 'Adel',
      'birthDate': '2000-01-15',
    });

    await insertUser({
      'email': 'tarekahmed@gmail.com',
      'firstName': 'Tarek',
      'lastName': 'Ahmed',
      'birthDate': '2001-03-20',
    });

    await insertUser({
      'email': 'sarakhaled@gmail.com',
      'firstName': 'Sara',
      'lastName': 'Khaled',
      'birthDate': '2002-07-10',
    });

    await insertUser({
      'email': 'nourtawfik@gmail.com',
      'firstName': 'Nour',
      'lastName': 'Tawfik',
      'birthDate': '2004-11-25',
    });

    await insertUser({
      'email': 'mahmoudsamir@gmail.com',
      'firstName': 'Mahmoud',
      'lastName': 'Samir',
      'birthDate': '2003-09-05',
    });

    await insertUser({
      'email': 'ahmedtamer@gmail.com',
      'firstName': 'Ahmed',
      'lastName': 'Tamer',
      'birthDate': '2003-04-30',
    });

    // Add Mohamed after the existing users
    await insertUser({
      'email': 'mohamedkhaled@gmail.com',
      'firstName': 'Mohamed',
      'lastName': 'Khaled',
      'birthDate': '2002-11-09',
    });

    // Create events
    final event1 = await insertEvent({
      'name': 'Birthday Party',
      'category': 'Personal',
      'status': 'Upcoming',
    });

    final event2 = await insertEvent({
      'name': 'Wedding Anniversary',
      'category': 'Celebration',
      'status': 'Planning',
    });

    final event3 = await insertEvent({
      'name': 'Graduation Ceremony',
      'category': 'Academic',
      'status': 'Upcoming',
    });

    // Add gifts with specific eventId
    await insertGift({
      'name': 'Smart Watch',
      'category': 'Electronics',
      'description':
          'Latest model smartwatch with fitness tracking and heart rate monitoring',
      'status': 'Available',
      'eventId': event1,
      'image': null,
    });

    await insertGift({
      'name': 'Luxury Watch',
      'category': 'Accessories',
      'description': 'Classic design stainless steel watch with leather strap',
      'status': 'Pledged',
      'eventId': event2,
      'image': null,
    });

    await insertGift({
      'name': 'MacBook Pro',
      'category': 'Electronics',
      'description':
          '16-inch MacBook Pro with M2 chip, perfect for professional work',
      'status': 'Available',
      'eventId': event3,
      'image': null,
    });

    await insertGift({
      'name': 'Professional Camera',
      'category': 'Photography',
      'description': 'DSLR camera with 24MP sensor and 4K video capability',
      'status': 'Pledged',
      'eventId': event3,
      'image': null,
    });

    await insertGift({
      'name': 'Gaming Console',
      'category': 'Electronics',
      'description':
          'Latest gaming console with two controllers and popular games',
      'status': 'Available',
      'eventId': event1,
      'image': null,
    });

    // Add more gifts for other events...
  }

  Future<List<Map<String, dynamic>>> getGiftsByEventId(int eventId) async {
    final db = await database;
    return await db?.query(
          'my_gifts',
          where: 'eventId = ?',
          whereArgs: [eventId],
        ) ??
        [];
  }

  Future<void> createTables(Database db) async {
    // First create my_events table
    await db.execute('''
      CREATE TABLE my_events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    // Then create my_gifts table with image column
    await db.execute('''
      CREATE TABLE my_gifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL,
        description TEXT,
        eventId INTEGER,
        image BLOB,
        FOREIGN KEY (eventId) REFERENCES my_events(id) ON DELETE CASCADE
      )
    ''');

    // Create friend_images table
    await db.execute('''
      CREATE TABLE friend_images(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        friend_name TEXT UNIQUE,
        image_path TEXT
      )
    ''');
  }

  Future<void> initializeFriendData() async {
    final db = await database;
    await db?.delete('friend_images');

    final List<Map<String, String>> friends = [
      {'name': 'Hassan', 'image_path': 'assets/images/hassan.jpeg'},
      {'name': 'Tarek', 'image_path': 'assets/images/tarek.jpeg'},
      {'name': 'Sara', 'image_path': 'assets/images/sara.jpeg'},
      {'name': 'Nour', 'image_path': 'assets/images/nour.jpeg'},
      {'name': 'Mahmoud', 'image_path': 'assets/images/mahmoud.jpeg'},
      {'name': 'Ahmed', 'image_path': 'assets/images/ahmed.jpeg'},
    ];

    for (var friend in friends) {
      await storeFriendImage(friend['name']!, friend['image_path']!);
    }
  }

  Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    final db = await database;
    return await db!.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db!.update(
      'users',
      {
        'firstName': user['firstName'],
        'lastName': user['lastName'],
        'birthDate': user['birthDate'],
      },
      where: 'email = ?',
      whereArgs: [user['email']],
    );
  }
}
