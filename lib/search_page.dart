import 'package:flutter/material.dart';
import '../services/search_db.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _historyFuture;


  final List<Map<String, String>> trendingTopics = [
    {
      "title": "Best Movie 2023",
      "subtitle": "Vote for your favorite",
      "image": "assets/images/images.jpg"
    },
    {
      "title": "Tech Innovations",
      "subtitle": "Leading the future",
      "image": "assets/images/images1.jpg"
    },
    {
      "title": "Top Anime 2023",
      "subtitle": "Pick your winner",
      "image": "assets/images/images.jpg"
    },
  ];

  final List<Map<String, String>> leadingOptions = [
    {
      "title": "Movie A",
      "subtitle": "45% of votes",
      "image": "assets/images/images.jpg"
    },
    {
      "title": "Movie B",
      "subtitle": "40% of votes",
      "image": "assets/images/images1.jpg"
    },
    {
      "title": "Movie C",
      "subtitle": "15% of votes",
      "image": "assets/images/images.jpg"
    },
  ];

  List<Map<String, String>> filteredTrending = [];
  List<Map<String, String>> filteredLeading = [];

  @override
  void initState() {
    super.initState();

    _historyFuture = SearchDB.getHistory();

    filteredTrending = List.from(trendingTopics);
    filteredLeading = List.from(leadingOptions);

    searchController.addListener(_filterContent);
  }

  void _filterContent() {
    final key = searchController.text.toLowerCase();

    setState(() {
      if (key.isEmpty) {
        filteredTrending = List.from(trendingTopics);
        filteredLeading = List.from(leadingOptions);
      } else {
        filteredTrending = trendingTopics
            .where((item) =>
                item["title"]!.toLowerCase().contains(key) ||
                item["subtitle"]!.toLowerCase().contains(key))
            .toList();

        filteredLeading = leadingOptions
            .where((item) =>
                item["title"]!.toLowerCase().contains(key) ||
                item["subtitle"]!.toLowerCase().contains(key))
            .toList();
      }
    });
  }
  Future<void> _doSearch(String q) async {
    final query = q.trim();
    if (query.isEmpty) return;

    await SearchDB.insertHistory(query);
    setState(() {
      _historyFuture = SearchDB.getHistory();
    });
  }

  Future<void> _clearHistory() async {
    await SearchDB.clearHistory();
    setState(() {
      _historyFuture = SearchDB.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Search",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PTSerif',
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey),
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) => _doSearch(value),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Riwayat Pencarian",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PTSerif',
                      ),
                    ),
                    TextButton(
                      onPressed: _clearHistory,
                      child: const Text("Clear"),
                    ),
                  ],
                ),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _historyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 60,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    final data = snapshot.data ?? [];

                    if (data.isEmpty) {
                      return const Text("Belum ada riwayat.");
                    }

                    return Column(
                      children: data.map((row) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(row['query'] ?? ''),
                          onTap: () {
                            searchController.text = row['query'] ?? '';
                          },
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Trending Topics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PTSerif',
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 180,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filteredTrending.map((item) {
                      return TrendingCard(
                        image: item["image"]!,
                        title: item["title"]!,
                        subtitle: item["subtitle"]!,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Leading Options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PTSerif',
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children: filteredLeading.map((item) {
                    return LeadingOption(
                      image: item["image"]!,
                      title: item["title"]!,
                      subtitle: item["subtitle"]!,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrendingCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const TrendingCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'PTSerif',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'PTSerif',
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeadingOption extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const LeadingOption({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'PTSerif',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: 'PTSerif'),
      ),
    );
  }
}
