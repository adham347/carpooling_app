import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'carpooling.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_profiles(
        name TEXT,
        email TEXT PRIMARY KEY
        -- Add other fields as needed
      )
    ''');
  }

  Future<int> insertUserProfile(Map<String, dynamic> userProfile) async {
    Database db = await instance.database;
    return await db.insert('user_profiles', userProfile);
  }

  Future<int> updateUserProfile(Map<String, dynamic> userProfile) async {
    Database db = await instance.database;
    return await db.update('user_profiles', userProfile);
  }
}
