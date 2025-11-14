import 'dart:async';

class DummyAPI {
  static final List<Map<String, dynamic>> _polls = [
    {
      "id": 1,
      "title": "Best Movie of 2024",
      "options": ["Dune 2", "Oppenheimer", "Barbie"],
      "votes": {"Dune 2": 10, "Oppenheimer": 6, "Barbie": 3},
    },
    {
      "id": 2,
      "title": "Best Series",
      "options": ["The Boys", "Loki", "Wednesday"],
      "votes": {"The Boys": 15, "Loki": 9, "Wednesday": 7},
    },
  ];

  /// GET /polls
  static Future<List<Map<String, dynamic>>> getPolls() async {
    await Future.delayed(const Duration(seconds: 1));
    return _polls;
  }

  /// POST /vote
  static Future<bool> vote(int pollId, String option) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final poll = _polls.firstWhere((p) => p["id"] == pollId);
    poll["votes"][option] = (poll["votes"][option] ?? 0) + 1;

    return true;
  }

  /// GET /results
  static Future<Map<String, dynamic>> getResults(int pollId) async {
    await Future.delayed(const Duration(seconds: 1));

    final poll = _polls.firstWhere((p) => p["id"] == pollId);
    return poll["votes"];
  }
}
