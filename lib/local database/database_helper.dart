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
      version: 3,
      onCreate: (Database db, int version) async {
        await createTables(db);
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
  Future<String?> getFriendImage(String friendName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db?.query(
          'friend_images',
          where: 'friend_name = ?',
          whereArgs: [friendName.toLowerCase()],
        ) ??
        [];

    if (maps.isNotEmpty) {
      return maps.first['image_path'];
    }
    return null;
  }

  Future<void> initializeSampleData() async {
    final db = await database;
    await db?.delete('my_events');
    await db?.delete('my_gifts');

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
      'name': 'Apple Watch',
      'category': 'Electronics',
      'status': 'Available',
      'eventId': event1,
      'image': null,
    });

    await insertGift({
      'name': 'PlayStation 5',
      'category': 'Gaming',
      'status': 'Pledged',
      'eventId': event1,
      'image': null,
    });

    await insertGift({
      'name': 'Diamond Ring',
      'category': 'Jewelry',
      'status': 'Available',
      'eventId': event2,
      'image': null,
    });

    await insertGift({
      'name': 'Luxury Watch',
      'category': 'Accessories',
      'status': 'Pledged',
      'eventId': event2,
      'image': null,
    });

    await insertGift({
      'name': 'MacBook Pro',
      'category': 'Electronics',
      'status': 'Available',
      'eventId': event3,
      'image': null,
    });

    await insertGift({
      'name': 'Professional Camera',
      'category': 'Photography',
      'status': 'Pledged',
      'eventId': event3,
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
}
