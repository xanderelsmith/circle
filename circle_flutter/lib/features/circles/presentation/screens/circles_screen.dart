import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';

import '../../../../client.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/widgets/circle_logo.dart';
import '../../../../theme.dart';
import '../../../activity/domain/activity.dart';
import '../../../activity/presentation/screens/activity_thread_screen.dart';
import 'package:circle_flutter/features/home/data/home_feed_provider.dart';

class CirclesScreen extends ConsumerStatefulWidget {
  const CirclesScreen({super.key});

  @override
  ConsumerState<CirclesScreen> createState() => _CirclesScreenState();
}

class _CirclesScreenState extends ConsumerState<CirclesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateCircleDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
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
                  ref.invalidate(circlesProvider);
                  if (newCircle.id != null) {
                    ref
                        .read(selectedCircleIdProvider.notifier)
                        .selectCircle(newCircle.id!);
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Created circle "$name"'),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
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

  void _openThread(CircleGroup circle) {
    if (circle.id != null) {
      ref.read(selectedCircleIdProvider.notifier).selectCircle(circle.id!);
    }

    final activity = Activity(
      id: (circle.id ?? 1).toString(),
      title: circle.name,
      description: 'Daily accountability circle',
      type: ActivityType.habit,
      duration: DurationOption.thirtyDays,
      proofRequirement: ProofRequirement.photo,
      visibility: VisibilityScope.onlyInCircle,
      iconEmoji: '🔥',
      memberCount: 8,
      isJoined: true,
      currentDay: 1,
      totalDays: 30,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityThreadScreen(activity: activity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final circlesAsync = ref.watch(circlesProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final userStreak = currentUser?.streakCount ?? 0;

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
                Text(
                  'My Circles',
                  style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: AppTheme.primaryBright,
              size: 28,
            ),
            onPressed: _showCreateCircleDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: circlesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryBright),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error loading circles: $err',
            style: const TextStyle(color: AppTheme.danger),
          ),
        ),
        data: (circles) {
          final filteredCircles = circles.where((c) {
            if (_searchQuery.isEmpty) return true;
            return c.name.toLowerCase().contains(_searchQuery);
          }).toList();

          return RefreshIndicator(
            color: AppTheme.primaryBright,
            onRefresh: () async {
              ref.invalidate(circlesProvider);
              await ref.read(circlesProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search your circles...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.textMuted,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tabs
                Row(
                  children: [
                    _buildTab(
                      0,
                      'My Circles',
                      '${circles.length}',
                      _activeTabIndex == 0,
                    ),
                    const SizedBox(width: 8),
                    _buildTab(1, 'Invites', '0', _activeTabIndex == 1),
                    const SizedBox(width: 8),
                    _buildTab(2, 'Suggested', '1', _activeTabIndex == 2),
                  ],
                ),
                const SizedBox(height: 24),

                if (filteredCircles.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.group_outlined,
                          size: 48,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No circles found',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create your own circle or seed starter data.',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Create Circle'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBright,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _showCreateCircleDialog,
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.bolt, size: 18),
                              label: const Text('Seed Sample'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryBright,
                                side: const BorderSide(
                                  color: AppTheme.primaryBright,
                                ),
                              ),
                              onPressed: () async {
                                await client.circle.seedDummyData();
                                ref.invalidate(circlesProvider);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredCircles.map((circle) {
                    final deadline = circle.dailyDeadline;
                    final timeStr =
                        '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
                    return _buildCircleCard(
                      circle: circle,
                      tagline: 'Daily deadline at $timeStr',
                      color: AppTheme.primaryBright,
                      streak: userStreak,
                      members: 4,
                      icon: Icons.landscape,
                    );
                  }),

                const SizedBox(height: 16),
                _buildStatsRow(
                  totalCircles: circles.length,
                  streak: userStreak,
                ),
                const SizedBox(height: 120), // room for bottom nav + FAB
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(int index, String title, String count, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.secondary : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (active) const Icon(Icons.group, size: 16, color: Colors.white),
            if (active) const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : AppTheme.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count,
              style: TextStyle(
                color: active ? Colors.white : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleCard({
    required CircleGroup circle,
    required String tagline,
    required Color color,
    required int streak,
    required int members,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _openThread(circle),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circle.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tagline,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.group,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$members members',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: AppTheme.success,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Active today',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '$streak d',
                    style: const TextStyle(
                      color: AppTheme.fire,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow({required int totalCircles, required int streak}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.group,
            '$totalCircles',
            'Circles',
            AppTheme.primaryBright,
          ),
          _buildStatItem(
            Icons.local_fire_department,
            '$streak',
            'Streak Days',
            AppTheme.fire,
          ),
          _buildStatItem(Icons.emoji_events, '1', 'Rank', AppTheme.gold),
          _buildStatItem(
            Icons.star,
            '${totalCircles * 2}',
            'Badges',
            AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
