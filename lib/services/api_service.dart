import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://your-api-link.com";

  static Future<Map<String, int>> getVotes() async {
    final res = await http.get(Uri.parse("$baseUrl/votes"));

    if (res.statusCode != 200) {
      return {};
    }
    return Map<String, int>.from(jsonDecode(res.body));
  }

  static Future<bool> submitVote(String title) async {
    final res = await http.post(
      Uri.parse("$baseUrl/vote"),
      body: {"title": title},
    );

    return res.statusCode == 200;
  }
}
