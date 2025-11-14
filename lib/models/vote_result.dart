class VoteResult {
  final String title;
  final int totalVotes;

  VoteResult({required this.title, required this.totalVotes});

  Map<String, dynamic> toMap() => {
    'title': title,
    'totalVotes': totalVotes,
  };

  factory VoteResult.fromMap(Map<String,dynamic> m) => VoteResult(
    title: m['title'] as String,
    totalVotes: (m['totalVotes'] as num).toInt(),
  );
}
