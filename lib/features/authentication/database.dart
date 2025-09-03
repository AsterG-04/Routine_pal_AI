import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL
      )
    ''');

    // Routines table (excluding uid)
    await db.execute('''
      CREATE TABLE routines (
        routine_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        favorite BOOLEAN DEFAULT false,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Activities table
    await db.execute('''
      CREATE TABLE activities (
        activity_id INTEGER PRIMARY KEY AUTOINCREMENT,
        routine_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        planned_time TEXT,
        FOREIGN KEY (routine_id) REFERENCES routines(routine_id) ON DELETE CASCADE
      )
    ''');

  }

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}


DocumentReference makeDatabaseReference(String userId) {
  return FirebaseFirestore.instance.collection('users').doc(userId);
}

