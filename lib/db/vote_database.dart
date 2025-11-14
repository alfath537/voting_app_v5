import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VoteDatabase {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), "votes.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE votes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pollId INTEGER,
            option TEXT
          )
        """);
      },
    );
  }

  static Future<void> saveVote(int pollId, String option) async {
    final database = await db;
    await database.insert("votes", {
      "pollId": pollId,
      "option": option,
    });
  }

  static Future<List<Map<String, dynamic>>> getVotes() async {
    final database = await db;
    return database.query("votes");
  }
}
