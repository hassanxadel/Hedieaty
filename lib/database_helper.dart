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
      CREATE TABLE Users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        preferences TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Events(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT,
        description TEXT,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Gifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT NOT NULL CHECK(status IN ('available', 'pledged', 'purchased')),
        eventId INTEGER NOT NULL,
        FOREIGN KEY (eventId) REFERENCES Events(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Friends(
        userId INTEGER NOT NULL,
        friendId INTEGER NOT NULL,
        PRIMARY KEY (userId, friendId),
        FOREIGN KEY (userId) REFERENCES Users(id) ON DELETE CASCADE,
        FOREIGN KEY (friendId) REFERENCES Users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE MyPledgedGifts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        giftId INTEGER NOT NULL,
        friendId INTEGER NOT NULL,
        pledgeDate TEXT NOT NULL,
        dueDate TEXT,
        FOREIGN KEY (giftId) REFERENCES Gifts(id) ON DELETE CASCADE,
        FOREIGN KEY (friendId) REFERENCES Users(id) ON DELETE CASCADE
      )
    ''');
  }

  // CRUD Operations for Users
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db?.insert('Users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db?.query('Users') ?? [];
  }

  Future<void> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    await db?.update('Users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db?.delete('Users', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Events
  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db?.insert('Events', event);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return await db?.query('Events') ?? [];
  }

  Future<void> updateEvent(int id, Map<String, dynamic> event) async {
    final db = await database;
    await db?.update('Events', event, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db?.delete('Events', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Gifts
  Future<void> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    await db?.insert('Gifts', gift);
  }

  Future<List<Map<String, dynamic>>> getGifts() async {
    final db = await database;
    return await db?.query('Gifts') ?? [];
  }

  Future<void> updateGift(int id, Map<String, dynamic> gift) async {
    final db = await database;
    await db?.update('Gifts', gift, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteGift(int id) async {
    final db = await database;
    await db?.delete('Gifts', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Friends
  Future<void> insertFriend(Map<String, dynamic> friend) async {
    final db = await database;
    await db?.insert('Friends', friend);
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final db = await database;
    return await db?.query('Friends') ?? [];
  }

  Future<void> deleteFriend(int userId, int friendId) async {
    final db = await database;
    await db?.delete('Friends',
        where: 'userId = ? AND friendId = ?', whereArgs: [userId, friendId]);
  }

  // CRUD Operations for MyPledgedGifts
  Future<void> insertPledgedGift(Map<String, dynamic> pledgedGift) async {
    final db = await database;
    await db?.insert('MyPledgedGifts', pledgedGift);
  }

  Future<List<Map<String, dynamic>>> getPledgedGifts() async {
    final db = await database;
    return await db?.query('MyPledgedGifts') ?? [];
  }

  Future<void> updatePledgedGift(
      int id, Map<String, dynamic> pledgedGift) async {
    final db = await database;
    await db?.update('MyPledgedGifts', pledgedGift,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deletePledgedGift(int id) async {
    final db = await database;
    await db?.delete('MyPledgedGifts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> checkDatabase() async {
    String databaseDestination = await getDatabasesPath();
    String databasePath = join(databaseDestination, 'hedieaty.db');
    bool exists = await databaseExists(databasePath);
    print(exists ? "Database exists" : "Database does not exist");
  }

  Future<void> resetDatabase() async {
    String databaseDestination = await getDatabasesPath();
    String databasePath = join(databaseDestination, 'hedieaty.db');
    await deleteDatabase(databasePath);
    print("Database reset");
  }
}
