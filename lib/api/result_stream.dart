import 'dart:async';
import 'dummy_api.dart';

class ResultStream {
  static Stream<Map<String, dynamic>> getResultStream(int pollId) {
    return Stream.periodic(
      const Duration(seconds: 2),
      (_) => DummyAPI.getResults(pollId),
    ).asyncMap((event) async => event);
  }
}
