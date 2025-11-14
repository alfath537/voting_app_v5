import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SearchDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('search_history.db');
    return _db!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  static Future<int> insertHistory(String query) async {
    final db = await database;
    return await db.insert('history', {
      'query': query,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return db.query('history', orderBy: 'created_at DESC');
  }

  static Future<int> clearHistory() async {
    final db = await database;
    return db.delete('history');
  }
}
