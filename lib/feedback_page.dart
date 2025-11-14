import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/dummy_api.dart';
import '../services/vote_db.dart';
import '../models/feedback_model.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _ctrl = TextEditingController();
  double _rating = 0.0;
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter feedback and rating')));
      return;
    }
    setState(() => _busy = true);

    final success = await DummyAPI.submitFeedback(_ctrl.text.trim(), _rating);
    if (success) {
      final f = FeedbackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        feedback: _ctrl.text.trim(),
        rating: _rating,
        userId: null,
        timestamp: DateTime.now().toIso8601String(),
      );
      await VoteDB.insertFeedback(f);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feedback submitted')));
      _ctrl.clear();
      setState(() => _rating = 0.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submit failed')));
    }

    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (c,i) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (r) => setState(() => _rating = r),
            ),
            const SizedBox(height: 24),
            TextField(controller: _ctrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Type your feedback', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _busy ? null : _submit, child: _busy ? const CircularProgressIndicator() : const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
