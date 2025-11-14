import 'package:flutter/material.dart';
import 'search_page.dart';
import 'saved_page.dart';
import 'profile_page.dart';
import 'movie_vote_page.dart';
import 'invite_friend_page.dart';
import 'notifications_page.dart';

import 'politics_page.dart';
import 'entertainment_page.dart';
import 'tvshows_page.dart';
import 'technology_page.dart';
import 'health_page.dart';
import 'education_page.dart';

import '../services/auth_prefs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final pages = <Widget>[]; 

  @override
  void initState() {
    super.initState();
    pages.addAll(const [HomeContent(), SearchPage(), SavedPage(), ProfilePage()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (i) => setState(() => selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String username = "Nichi"; 

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final email = await AuthPrefs.getEmail();
    if (email != null && email.isNotEmpty) {
      final name = email.split('@')[0];
      if (mounted) {
        setState(() {
          username = name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header greeting + profile + notif icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/imagespp.png',
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Hi, $username 👋",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PTSerif',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                "Vote Now",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PTSerif',
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              GestureDetector(
                onTap: () {
                  final homeState = context.findAncestorStateOfType<HomePageState>();
                  homeState?.setState(() {
                    homeState.selectedIndex = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text(
                        "Search polls",
                        style: TextStyle(
                          fontFamily: 'PTSerif',
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PTSerif',
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    CategoryChip(
                      label: 'Politics',
                      icon: Icons.account_balance,
                      page: PoliticsPage(),
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(
                      label: 'Entertainment',
                      icon: Icons.movie,
                      page: EntertainmentPage(),
                      color: Colors.purple,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(
                      label: 'TV Shows',
                      icon: Icons.tv,
                      page: TopTVShowsPage(),
                      color: Colors.teal,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(
                      label: 'Technology',
                      icon: Icons.devices,
                      page: TechnologyPage(),
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(
                      label: 'Health',
                      icon: Icons.health_and_safety,
                      page: HealthPage(),
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    CategoryChip(
                      label: 'Education',
                      icon: Icons.school,
                      page: EducationPage(),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Trending Polls
              const Text(
                "Trending Polls",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PTSerif',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PollCard(
                      image: 'assets/images/images.jpg',
                      title: "Best Movie 2023",
                      subtitle: "Vote for your favorite",
                      voters: 320,
                      isPopular: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MovieVotePage(),
                          ),
                        );
                      },
                    ),
                    const PollCard(
                      image: 'assets/images/images1.jpg',
                      title: "Tech Innovations",
                      subtitle: "Choose the best",
                      voters: 150,
                      isPopular: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Invite Friends Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    'Invite Friends',
                    style: TextStyle(fontFamily: 'PTSerif'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InviteFriendPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget page;
  final Color color;

  const CategoryChip({
    required this.label,
    required this.icon,
    required this.page,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, color: Colors.white, size: 20),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}

class PollCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final int voters;
  final bool isPopular;
  final VoidCallback? onTap;

  const PollCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.voters,
    required this.isPopular,
    this.onTap,
    super.key,
  });

  @override
  State<PollCard> createState() => _PollCardState();
}

class _PollCardState extends State<PollCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '🔥 Popular',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'PTSerif',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontFamily: 'PTSerif',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.voters} votes',
                    style: const TextStyle(
                      fontFamily: 'PTSerif',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Icon save di kanan atas
          Positioned(
            top: 10,
            right: 20,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSaved = !isSaved;
                });
                debugPrint('${widget.title} saved: $isSaved');
              },
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
