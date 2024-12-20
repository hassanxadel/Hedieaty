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
      version: 1,
      onCreate: (Database db, int version) async {
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
      case 'mohamed':
        return 'assets/images/mohamed.jpeg';
      default:
        return 'assets/images/default_avatar';
    }
  }

  Future<void> initializeSampleData() async {
    final db = await database;
    if (db == null) return;

    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete('users');
      await txn.delete('my_events');
      await txn.delete('my_gifts');

      // Add sample user
      await txn.insert('users', {
        'email': 'hassanadelh@gmail.com',
        'firstName': 'Hassan',
        'lastName': 'Adel',
        'birthDate': '2000-01-15',
      });

      final eventId = await txn.insert('my_events', {
        'name': 'Birthdayyy Party',
        'category': 'Birthday',
        'status': 'Upcoming'
      });

      // Add sample gift
      await txn.insert('my_gifts', {
        'name': 'Birthday Gift',
        'category': 'Electronics',
        'status': 'Avaliable',
        'description': 'A nice gift',
        'eventId': eventId,
      });
    });
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
    // Create users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        email TEXT PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        birthDate TEXT
      )
    ''');

    // Create events table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS my_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        status TEXT
      )
    ''');

    // Create gifts table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS my_gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        category TEXT,
        status TEXT,
        description TEXT,
        eventId INTEGER,
        FOREIGN KEY (eventId) REFERENCES my_events (id)
      )
    ''');

    // Create friend_images table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS friend_images (
        friend_name TEXT PRIMARY KEY,
        image_path TEXT
      )
    ''');
  }

  Future<void> initializeFriendData() async {
    final db = await database;
    await db?.delete('friend_images');

    final List<Map<String, String>> myfriends = [
      {'name': 'Hassan', 'image_path': 'assets/images/hassan.jpeg'},
      {'name': 'Tarek', 'image_path': 'assets/images/tarek.jpeg'},
      {'name': 'Sara', 'image_path': 'assets/images/sara.jpeg'},
      {'name': 'Nour', 'image_path': 'assets/images/nour.jpeg'},
      {'name': 'Mahmoud', 'image_path': 'assets/images/mahmoud.jpeg'},
      {'name': 'Ahmed', 'image_path': 'assets/images/ahmed.jpeg'},
      {'name': 'Mohamed', 'image_path': 'assets/images/mohamed.jpeg'},
    ];

    for (var friend in myfriends) {
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

  static Future<void> initialize() async {
    try {
      final instance = DatabaseHelper();
      final db = await instance._initDatabase();

      // Create tables first
      await instance.createTables(db);

      // Then check for data
      final List<Map<String, dynamic>> users = await db.query('users');
      if (users.isEmpty) {
        await instance.initializeSampleData();
        await instance.initializeFriendData();
        print('Database initialized with sample data');
      } else {
        print('Database already contains data');
      }
    } catch (e) {
      print('Database initialization error: $e');
      rethrow;
    }
  }
}
