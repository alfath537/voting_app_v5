import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<bool> hasVoted(String title) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('voted_$title') ?? false;
  }

  static Future<void> setVoted(String title) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('voted_$title', true);
  }

  static Future<bool> isBookmarked(String id) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('bookmark_$id') ?? false;
  }

  static Future<void> toggleBookmark(String id) async {
    final p = await SharedPreferences.getInstance();
    final cur = p.getBool('bookmark_$id') ?? false;
    await p.setBool('bookmark_$id', !cur);
  }
}
