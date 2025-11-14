import 'package:flutter/material.dart';

class ShareMoviePage extends StatelessWidget {
  const ShareMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Movie')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Share this poll with your friends:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: [
                _buildShareOption(Icons.facebook, 'Facebook'),
                _buildShareOption(Icons.alternate_email, 'Twitter'),
                _buildShareOption(Icons.camera_alt, 'Instagram'),
                _buildShareOption(Icons.chat, 'WhatsApp'),
                _buildShareOption(Icons.email, 'Email'),
                _buildShareOption(Icons.copy, 'Copy Link'),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        debugPrint('Clicked $label');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontFamily: 'PTSerif')),
        ],
      ),
    );
  }
}