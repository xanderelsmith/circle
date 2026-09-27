import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/proof_card.dart';
import '../widgets/custom_tab_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Uses atmospheric gradient from main
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            // Logo placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3D7BFF), width: 3),
              ),
              child: const Icon(Icons.circle_outlined, color: Color(0xFF42D9FF)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Circle',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: const [
                    Text(
                      'My Circle',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              child: Icon(Icons.notifications_none, size: 28),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CustomTabBar(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childCount: dummyPosts.length,
              itemBuilder: (context, index) {
                return ProofCard(post: dummyPosts[index]);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)), // padding for bottom nav
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF7C4DFF),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF080F20),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: const Color(0xFF6F7B9A),
        currentIndex: 1, // Circles active
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Circles'),
          BottomNavigationBarItem(
            icon: Badge(child: Icon(Icons.chat_bubble_outline)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// Dummy Data
class ProofPostData {
  final String imageUrl;
  final String username;
  final String timeAgo;
  final String habitName;
  final String caption;
  final int streak;
  final int flames;
  final int comments;
  final double cardHeight; // to simulate masonry

  ProofPostData({
    required this.imageUrl,
    required this.username,
    required this.timeAgo,
    required this.habitName,
    required this.caption,
    required this.streak,
    required this.flames,
    required this.comments,
    required this.cardHeight,
  });
}

final dummyPosts = [
  ProofPostData(
    imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500&q=80',
    username: 'Emmanuel',
    timeAgo: '2h ago',
    habitName: 'Run 5km',
    caption: 'Finally got it done. No excuses this time. 💪',
    streak: 18,
    flames: 42,
    comments: 6,
    cardHeight: 320,
  ),
  ProofPostData(
    imageUrl: 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=500&q=80',
    username: 'Sarah',
    timeAgo: '4h ago',
    habitName: 'Read 20 pages',
    caption: 'Small steps, big dreams. 📚',
    streak: 7,
    flames: 28,
    comments: 3,
    cardHeight: 260,
  ),
  ProofPostData(
    imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&q=80',
    username: 'Chioma',
    timeAgo: '6h ago',
    habitName: 'Eat healthy',
    caption: 'Clean food, better mood. 🌱',
    streak: 3,
    flames: 16,
    comments: 1,
    cardHeight: 280,
  ),
  ProofPostData(
    imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&q=80',
    username: 'David',
    timeAgo: '5h ago',
    habitName: 'Gym Workout',
    caption: 'Leg day done 💪',
    streak: 11,
    flames: 21,
    comments: 2,
    cardHeight: 260,
  ),
];
