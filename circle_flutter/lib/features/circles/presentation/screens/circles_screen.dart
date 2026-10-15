import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';

import '../../../../client.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/providers/notification_count_provider.dart';
import '../../../../core/widgets/failure.dart';
import '../../../../core/widgets/shimmer.dart';
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
  final _inviteCodeController = TextEditingController();
  String _searchQuery = '';
  int _activeTabIndex = 0;

  // Pending invitations (no backend source yet, so starts empty)
  final List<Map<String, dynamic>> _pendingInvites = [];

  // Suggested circles (no backend source yet, so starts empty)
  final List<Map<String, dynamic>> _suggestedCircles = const [];

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
    _inviteCodeController.dispose();
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
    ref.watch(feedNotificationSyncProvider);
    final notifCount = ref.watch(notificationCountProvider);

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
            icon: Badge(
              isLabelVisible: notifCount > 0,
              label: Text(
                notifCount > 99 ? '99+' : '$notifCount',
                style: const TextStyle(fontSize: 10),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: AppTheme.textPrimary,
                size: 28,
              ),
            ),
            onPressed: () {
              ref.read(notificationCountProvider.notifier).clear();
              Navigator.of(context).pushNamed('/notifications');
            },
          ),
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
        loading: () => const ShimmerList(
          itemCount: 4,
          itemHeight: 120,
          showTrailing: true,
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FailureWidget(
              title: 'Unable to load circles',
              message: 'Check your connection and try again.',
              onRetry: () => ref.invalidate(circlesProvider),
            ),
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
                    _buildTab(
                      1,
                      'Invites',
                      '${_pendingInvites.length}',
                      _activeTabIndex == 1,
                    ),
                    const SizedBox(width: 8),
                    _buildTab(
                      2,
                      'Suggested',
                      '${_suggestedCircles.length}',
                      _activeTabIndex == 2,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                if (_activeTabIndex == 0) ...[
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
                ] else if (_activeTabIndex == 1) ...[
                  _buildInvitesTab(),
                ] else if (_activeTabIndex == 2) ...[
                  _buildSuggestedTab(circles),
                ],
                const SizedBox(height: 120), // room for bottom nav + FAB
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvitesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Join with Circle Code
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.vpn_key_rounded,
                    color: AppTheme.primaryBright,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Enter Circle Invite Code',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter a 6-digit code or circle name shared by a friend to join their circle instantly.',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inviteCodeController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'e.g. ALPHA-92',
                        hintStyle: const TextStyle(color: AppTheme.textMuted),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBright,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final code = _inviteCodeController.text.trim();
                      if (code.isEmpty) return;
                      _inviteCodeController.clear();
                      try {
                        final created = await client.circle.createCircle(
                          CircleGroup(
                            name: code,
                            dailyDeadline: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                          ),
                        );
                        ref.invalidate(circlesProvider);
                        if (created.id != null) {
                          ref
                              .read(selectedCircleIdProvider.notifier)
                              .selectCircle(created.id!);
                        }
                        setState(() => _activeTabIndex = 0);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Joined circle "$code"!'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to join: $e'),
                              backgroundColor: AppTheme.danger,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Join',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Pending Invitations
        const Text(
          'Pending Invitations',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_pendingInvites.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.mail_outline_rounded,
                  color: AppTheme.textMuted,
                  size: 36,
                ),
                SizedBox(height: 8),
                Text(
                  'No pending invitations',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
              ],
            ),
          )
        else
          ..._pendingInvites.map((inv) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.primaryBright.withValues(
                      alpha: 0.2,
                    ),
                    child: const Icon(
                      Icons.group_add_rounded,
                      color: AppTheme.primaryBright,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inv['circleName'] as String,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Invited by ${inv['invitedBy']} • ${inv['members']} members',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppTheme.danger,
                          size: 22,
                        ),
                        tooltip: 'Decline',
                        onPressed: () {
                          setState(() {
                            _pendingInvites.removeWhere(
                              (i) => i['id'] == inv['id'],
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Declined invite from ${inv['circleName']}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBright,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final name = inv['circleName'] as String;
                          setState(() {
                            _pendingInvites.removeWhere(
                              (i) => i['id'] == inv['id'],
                            );
                          });
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
                            setState(() => _activeTabIndex = 0);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Accepted invite to "$name"!'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Joined "$name"!'),
                                  backgroundColor: AppTheme.success,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 20),
        // 3. Share personal invite link
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Your Circle Invite Code',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'CIRCLE-MY-99',
                      style: TextStyle(
                        color: AppTheme.primaryBright,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBright,
                  side: const BorderSide(color: AppTheme.primaryBright),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: 'CIRCLE-MY-99'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invite code copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedTab(List<CircleGroup> myCircles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular & Recommended Circles',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Join circles aligned with your daily goals and build momentum together.',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 16),
        if (_suggestedCircles.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.explore_outlined,
                  color: AppTheme.textMuted,
                  size: 36,
                ),
                SizedBox(height: 8),
                Text(
                  'No suggested circles yet',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),
        ..._suggestedCircles.map((sug) {
          final isAlreadyJoined = myCircles.any(
            (c) =>
                c.name.toLowerCase() == (sug['name'] as String).toLowerCase(),
          );
          final color = sug['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20),
              border: Border(left: BorderSide(color: color, width: 4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(sug['icon'] as IconData, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sug['name'] as String,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sug['tagline'] as String,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.group,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${sug['members']} members',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text('🔥', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '${sug['streak']}d streak',
                            style: const TextStyle(
                              color: AppTheme.fire,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isAlreadyJoined)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check, size: 14, color: AppTheme.success),
                        SizedBox(width: 4),
                        Text(
                          'Joined',
                          style: TextStyle(
                            color: AppTheme.success,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBright,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final name = sug['name'] as String;
                      try {
                        final created = await client.circle.createCircle(
                          CircleGroup(
                            name: name,
                            dailyDeadline: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                          ),
                        );
                        ref.invalidate(circlesProvider);
                        if (created.id != null) {
                          ref
                              .read(selectedCircleIdProvider.notifier)
                              .selectCircle(created.id!);
                        }
                        setState(() => _activeTabIndex = 0);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Joined "$name"!'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to join: $e'),
                              backgroundColor: AppTheme.danger,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Join',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
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
