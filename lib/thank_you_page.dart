import 'package:flutter/material.dart';
import 'movie_vote_page.dart';
import 'view_results_page.dart';
import 'share_movie_page.dart';
import 'feedback_page.dart';

class ThankYouPage extends StatelessWidget {
  final String title;
  final String imagePath;

  const ThankYouPage({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        )
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Thank You!',
            style: TextStyle(
              fontFamily: 'PTSerif',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          /// --- FIX UTAMA di sini ---
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MovieVotePage()),
                ),
                child: const Text('Vote Again'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewResultsPage()),
                ),
                child: const Text('View Results'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShareMoviePage()),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.share, size: 30),
                      SizedBox(height: 4),
                      Text("Share"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: const [
                      Icon(Icons.person_add, size: 30),
                      SizedBox(height: 4),
                      Text("Invite Friends"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FeedbackPage()),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.feedback, size: 30),
                      SizedBox(height: 4),
                      Text("Feedback"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
