import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vote_result.dart';
import '../models/feedback_model.dart';

class VoteDB {
  static Database? _db;

  static Future<Database> database() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'voting_app.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE votes(
          title TEXT PRIMARY KEY,
          totalVotes INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE feedbacks(
          id TEXT PRIMARY KEY,
          feedback TEXT,
          rating REAL,
          userId TEXT,
          timestamp TEXT
        )
      ''');
    });

    return _db!;
  }

  // votes
  static Future<void> saveResults(Map<String,int> map) async {
    final db = await database();
    final batch = db.batch();
    map.forEach((title, total) {
      batch.insert('votes', {'title': title, 'totalVotes': total},
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
  }

  static Future<List<VoteResult>> getAllResults() async {
    final db = await database();
    final rows = await db.query('votes', orderBy: 'totalVotes DESC');
    return rows.map((r) => VoteResult.fromMap(r)).toList();
  }

  // feedbacks
  static Future<void> insertFeedback(FeedbackModel f) async {
    final db = await database();
    await db.insert('feedbacks', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<FeedbackModel>> getAllFeedbacks() async {
    final db = await database();
    final rows = await db.query('feedbacks', orderBy: 'timestamp DESC');
    return rows.map((r) => FeedbackModel.fromMap(r)).toList();
  }
}
