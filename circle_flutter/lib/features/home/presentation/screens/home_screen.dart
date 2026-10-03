import 'package:circle_flutter/features/home/data/home_feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme.dart';
import '../../../../core/widgets/circle_logo.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/proof_card.dart';

// import '../data/home_feed_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(homeFeedProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleLogo(size: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Circle',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'My Circle',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
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
          feedAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryBright),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No proof posts yet in this circle',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverMasonryGrid.extent(
                  maxCrossAxisExtent: 380,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childCount: posts.length,
                  itemBuilder: (context, index) {
                    final p = posts[index];
                    final uiData = ProofPostData(
                      imageUrl: p.imageUrl.isEmpty
                          ? 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500&q=80'
                          : p.imageUrl,
                      username: 'User ${p.userId}',
                      timeAgo:
                          '${DateTime.now().difference(p.createdAt).inHours}h ago',
                      habitName: 'Habit challenge',
                      caption: p.caption,
                      streak: 0,
                      flames: 0,
                      comments: 0,
                      cardHeight: 280,
                    );
                    return ProofCard(post: uiData);
                  },
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ), // padding for bottom nav
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Dummy data mapping
// -----------------------------------------------------------------------------
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
