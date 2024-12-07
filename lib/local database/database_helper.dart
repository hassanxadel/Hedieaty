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
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE my_gifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE my_gifts_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        giftId INTEGER,
        detail TEXT NOT NULL,
        FOREIGN KEY (giftId) REFERENCES my_gifts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        birthDate TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations for Events
  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db?.insert('my_events', event);
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
}
