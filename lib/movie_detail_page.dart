import 'package:flutter/material.dart';
import '../services/prefs_helper.dart';
import '../services/vote_service.dart';
import 'thank_you_page.dart';
import 'share_movie_page.dart';

class MovieDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;
  const MovieDetailPage({super.key, required this.title, required this.imagePath});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isVoting = false;
  bool _hasVoted = false;

  @override
  void initState() {
    super.initState();
    _loadVoteStatus();
  }

  Future<void> _loadVoteStatus() async {
    _hasVoted = await PrefsHelper.hasVoted(widget.title);
    setState(() {});
  }

  Future<void> _vote() async {
    if (_hasVoted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already voted for this movie')));
      return;
    }
    setState(() => _isVoting = true);
    final success = await VoteService.submitVote(widget.title);
    if (success) {
      await PrefsHelper.setVoted(widget.title);
      setState(() => _hasVoted = true);
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ThankYouPage(title: '', imagePath: '',)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vote failed')));
    }
    setState(() => _isVoting = false);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title;
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Hero(tag: title, child: ClipRRect(borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), child: Image.asset(widget.imagePath, width: double.infinity, height: 250, fit: BoxFit.cover))),
        Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'PTSerif', fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Director: Tina Fey', style: TextStyle(fontFamily: 'PTSerif')),
          const SizedBox(height: 12),
          const Text('A thrilling adventure of a lifetime. Join the characters in an emotional journey filled with drama, humor, and unforgettable moments.', style: TextStyle(fontFamily: 'PTSerif')),
        ])),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)), onPressed: _isVoting ? null : _vote, child: _isVoting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_hasVoted ? 'Voted' : 'Vote', style: const TextStyle(color: Colors.white))),
          OutlinedButton(style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareMoviePage())), child: const Text('Share')),
        ]),
        const SizedBox(height: 24),
      ])),
    );
  }
}
