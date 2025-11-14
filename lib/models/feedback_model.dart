class FeedbackModel {
  final String id;
  final String feedback;
  final double rating;
  final String? userId;
  final String timestamp;

  FeedbackModel({
    required this.id,
    required this.feedback,
    required this.rating,
    this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'feedback': feedback,
    'rating': rating,
    'userId': userId,
    'timestamp': timestamp,
  };

  factory FeedbackModel.fromMap(Map<String, dynamic> m) => FeedbackModel(
    id: m['id'] as String,
    feedback: m['feedback'] as String,
    rating: (m['rating'] as num).toDouble(),
    userId: m['userId'] as String?,
    timestamp: m['timestamp'] as String,
  );
}
