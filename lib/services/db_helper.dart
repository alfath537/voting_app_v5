import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'voting_app.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE feedbacks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          feedback TEXT NOT NULL,
          rating REAL NOT NULL,
          timestamp TEXT NOT NULL,
          userId TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE votes_cache(
          movie TEXT PRIMARY KEY,
          count INTEGER
        )
      ''');
    });
    return _db!;
  }

  static Future<int> insertFeedback(String feedback, double rating, {String? userId}) async {
    final db = await database();
    return db.insert('feedbacks', {
      'feedback': feedback,
      'rating': rating,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': userId
    });
  }

  static Future<List<Map<String, dynamic>>> getAllFeedbacks() async {
    final db = await database();
    return db.query('feedbacks', orderBy: 'timestamp DESC');
  }

  static Future<void> upsertVote(String movie, int count) async {
    final db = await database();
    await db.insert('votes_cache', {'movie': movie, 'count': count}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getVotesCache() async {
    final db = await database();
    return db.query('votes_cache');
  }
}
