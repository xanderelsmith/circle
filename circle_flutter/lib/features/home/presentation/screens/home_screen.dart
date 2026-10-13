import 'package:circle_flutter/features/home/data/home_feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../../client.dart';
import '../../../../core/widgets/failure.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../theme.dart';
import '../../../../core/widgets/circle_logo.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/proof_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(homeFeedProvider);
    final usersMap = ref.watch(usersMapProvider).value ?? {};
    final circlesAsync = ref.watch(circlesProvider);
    final currentCircleId = ref.watch(selectedCircleIdProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: circlesAsync.when(
          loading: () => _buildAppBarTitle('Loading...', onTap: null),
          error: (_, __) => _buildAppBarTitle('Error', onTap: null),
          data: (circles) {
            if (circles.isEmpty) {
              return _buildAppBarTitle('No Circles', onTap: null);
            }
            final circleMatch = circles.where((c) => c.id == currentCircleId);
            final currentCircle = circleMatch.isNotEmpty
                ? circleMatch.first
                : circles.first;
            final currentCircleName = currentCircle.name;

            return _buildAppBarTitle(
              currentCircleName,
              onTap: () => _showCircleSelector(context, ref, circles, currentCircleId),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Badge(
              child: Icon(Icons.notifications_none, size: 28),
            ),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
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
                child: ShimmerProfileCard(),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FailureWidget(
                    title: 'Unable to load feed',
                    message: 'Check your connection and try again.',
                    onRetry: () => ref.invalidate(homeFeedProvider),
                  ),
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
                    final author = usersMap[p.userId];
                    final username = author?.username ?? 'User ${p.userId}';
                    final streak = author?.streakCount ?? 1;
                    final hoursAgo = DateTime.now()
                        .difference(p.createdAt)
                        .inHours;
                    final timeAgo = hoursAgo <= 0
                        ? 'Just now'
                        : '${hoursAgo}h ago';

                    final uiData = ProofPostData(
                      imageUrl: p.imageUrl.isEmpty
                          ? 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500&q=80'
                          : p.imageUrl,
                      username: username,
                      timeAgo: timeAgo,
                      habitName: 'Daily Habit',
                      caption: p.caption,
                      streak: streak,
                      flames: 0,
                      comments: 0,
                      cardHeight: index.isEven ? 280 : 320,
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

  Widget _buildAppBarTitle(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          const CircleLogo(size: 40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
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
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
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
    );
  }

  void _showCircleSelector(
    BuildContext context,
    WidgetRef ref,
    List<CircleGroup> circles,
    int currentCircleId,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CircleSelectorSheet(
        circles: circles,
        currentCircleId: currentCircleId,
        onSelect: (circleId) {
          ref.read(selectedCircleIdProvider.notifier).selectCircle(circleId);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}

class _CircleSelectorSheet extends ConsumerWidget {
  const _CircleSelectorSheet({
    required this.circles,
    required this.currentCircleId,
    required this.onSelect,
  });

  final List<CircleGroup> circles;
  final int currentCircleId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1526),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              'Select Circle',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          ...circles.map((circle) {
            final isSelected = circle.id == currentCircleId;
            return InkWell(
              onTap: () => onSelect(circle.id ?? 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryBright.withValues(alpha: 0.2),
                      child: const Icon(Icons.group, color: AppTheme.primaryBright, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            circle.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Daily deadline: ${_formatDeadline(circle.dailyDeadline)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryBright,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          // Create new circle button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create New Circle'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBright,
                      side: const BorderSide(color: AppTheme.primaryBright),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showCreateCircleDialog(context, ref);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    return '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
  }

  void _showCreateCircleDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Create New Circle',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Flutter Builders',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Please enter a circle name';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBright,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final name = nameController.text.trim();
                Navigator.of(ctx).pop();

                try {
                  final newCircle = await client.circle.createCircle(
                    CircleGroup(
                      name: name,
                      dailyDeadline: DateTime.now().add(
                        const Duration(days: 1),
                      ),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  ref.invalidate(circlesProvider);
                  if (newCircle.id != null) {
                    ref
                        .read(selectedCircleIdProvider.notifier)
                        .selectCircle(newCircle.id!);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Created circle "$name"'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create circle: $e'),
                        backgroundColor: AppTheme.danger,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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