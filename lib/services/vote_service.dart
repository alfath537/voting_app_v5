import 'dummy_api.dart';
import 'vote_db.dart';

class VoteService {
  static Future<bool> submitVote(String title) async {
    try {
      final success = await DummyAPI.vote(title);
      if (!success) return false;

      final current = await DummyAPI.getVotes();
      await VoteDB.saveResults(current);
      return true;
    } catch (e) {
      print('VoteService.submitVote error: $e');
      return false;
    }
  }

  static Future<Map<String,int>> fetchVotes() async {
    try {
      final map = await DummyAPI.getVotes();
      await VoteDB.saveResults(map);
      return map;
    } catch (e) {
      final offline = await VoteDB.getAllResults();
      return {for (var v in offline) v.title: v.totalVotes};
    }
  }
}
