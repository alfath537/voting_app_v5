import 'dart:async';
import 'vote_service.dart';

class VoteStream {
  static Stream<Map<String,int>> polling({Duration interval = const Duration(seconds: 3)}) async* {
    while (true) {
      try {
        final data = await VoteService.fetchVotes();
        yield data;
      } catch (_) {
        yield {};
      }
      await Future.delayed(interval);
    }
  }
}
