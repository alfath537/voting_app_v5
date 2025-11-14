import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FeedbackDB {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'feedback.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
        CREATE TABLE feedback(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          feedback TEXT NOT NULL,
          rating REAL NOT NULL,
          createdAt TEXT
        )
        """);
      },
    );
    return _db!;
  }

  static Future<void> insertFeedback(String feedback, double rating) async {
    final db = await database();
    await db.insert("feedback", {
      "feedback": feedback,
      "rating": rating,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getFeedbacks() async {
    final db = await database();
    return db.query("feedback", orderBy: "createdAt DESC");
  }
}
