import 'package:flutter/material.dart';
import '../services/vote_db.dart';
import '../models/feedback_model.dart';

class ViewFeedbackPage extends StatefulWidget {
  const ViewFeedbackPage({super.key});
  @override
  State<ViewFeedbackPage> createState() => _ViewFeedbackPageState();
}

class _ViewFeedbackPageState extends State<ViewFeedbackPage> {
  List<FeedbackModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _items = await VoteDB.getAllFeedbacks();
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Feedbacks')),
      body: _items.isEmpty ? const Center(child: Text('No feedbacks yet')) : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _items.length,
        separatorBuilder: (_,__) => const Divider(),
        itemBuilder: (c,i) {
          final f = _items[i];
          return ListTile(
            title: Text(f.feedback),
            subtitle: Text('${f.rating} ★ • ${f.timestamp}'),
          );
        },
      ),
    );
  }
}
