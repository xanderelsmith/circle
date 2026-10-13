import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';

import '../../../../client.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../core/widgets/failure.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../theme.dart';
import '../../../leaderboard/data/leaderboard_provider.dart';
import '../../../leaderboard/widgets/leaderboard_tile.dart';
import '../../../leaderboard/domain/leaderboard_entry.dart';
import '../../data/chat_provider.dart';
import '../../domain/activity.dart';
import '../screens/add_proof_screen.dart';
import '../screens/widgets/activity_header_card.dart';
import '../screens/widgets/composer_bar.dart';
import '../screens/widgets/thread_post_tile.dart';

class ActivityThreadScreen extends ConsumerStatefulWidget {
  const ActivityThreadScreen({super.key, required this.activity});

  final Activity activity;

  @override
  ConsumerState<ActivityThreadScreen> createState() =>
      _ActivityThreadScreenState();
}

class _ActivityThreadScreenState extends ConsumerState<ActivityThreadScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _commentController = TextEditingController();

  // Local mutable copy so newly posted proofs appear immediately.
  late final List<ActivityPost> _posts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _posts = List.of(samplePosts);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _openAddProof() async {
    final result = await Navigator.of(context).push<ActivityPost>(
      MaterialPageRoute(
        builder: (_) => AddProofScreen(activity: widget.activity),
        fullscreenDialog: true,
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _posts.insert(0, result);
      _tabController.animateTo(0);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proof posted by ${result.authorName}'),
        backgroundColor: AppTheme.primaryBright,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _handleSendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final currentUser = ref.read(currentUserProvider).value;
    final groupId = int.tryParse(widget.activity.id) ?? 1;

    final msg = ChatMessage(
      userId: currentUser?.id ?? 1,
      groupId: groupId,
      message: text,
      createdAt: DateTime.now(),
    );

    _commentController.clear();
    FocusScope.of(context).unfocus();

    // Immediately reflect comment locally in the thread
    setState(() {
      _posts.insert(
        0,
        ActivityPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: currentUser?.username ?? 'You',
          authorAvatarUrl:
              'https://i.pravatar.cc/150?u=${currentUser?.id ?? 1}',
          timeAgo: 'Just now',
          imageUrl: '',
          imageBadge: 'Comment',
          caption: text,
          fireCount: 0,
          respectCount: 0,
          pushCount: 0,
          commentCount: 0,
        ),
      );
      _tabController.animateTo(0);
    });

    try {
      await client.chat.postMessage(msg);
      ref.invalidate(groupChatMessagesProvider(groupId));
    } catch (_) {
      // Backend gracefully handled
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const _ThreadHeader(),
              Expanded(
                child: Column(
                  children: [
                    // Activity header card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: ActivityHeaderCard(activity: widget.activity),
                    ),

                    // Tab bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _InnerTabs(controller: _tabController),
                    ),
                    const SizedBox(height: 12),

                    // Body
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _ThreadTab(posts: _posts),
                          const _MembersTab(),
                          const _LeaderboardTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Composer — camera wired, send wired to Serverpod chat
              ComposerBar(
                controller: _commentController,
                onCameraTap: _openAddProof,
                onSend: _handleSendComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadHeader extends StatelessWidget {
  const _ThreadHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
            color: AppTheme.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Expanded(
            child: Text(
              'Activity Thread',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded, size: 24),
            color: AppTheme.textPrimary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _InnerTabs extends StatelessWidget {
  const _InnerTabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1224),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: List.generate(3, (i) {
              final labels = ['Thread', 'Members', 'Leaderboard'];
              final selected = controller.index == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.animateTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      gradient: selected ? AppTheme.primaryGradient : null,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryBright.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _ThreadTab extends StatelessWidget {
  const _ThreadTab({required this.posts});

  final List<ActivityPost> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        return ThreadPostTile(
          post: posts[i],
          isFirst: i == 0,
          isLast: i == posts.length - 1,
        );
      },
    );
  }
}

class _MembersTab extends ConsumerWidget {
  const _MembersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(leaderboardProvider);

    return usersAsync.when(
      loading: () => const ShimmerList(itemCount: 6, itemHeight: 68),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FailureWidget(
            title: 'Unable to load members',
            message: 'Check your connection and try again.',
            onRetry: () => ref.invalidate(leaderboardProvider),
          ),
        ),
      ),
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Text(
              'No members in this circle yet',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          itemCount: users.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final user = users[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1224),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      'https://i.pravatar.cc/100?u=${user.id}',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 40,
                        height: 40,
                        color: AppTheme.surfaceLight,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person,
                          size: 20,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${user.streakCount} day streak · ${user.rankColor ?? 'Rookie'}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(leaderboardProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return usersAsync.when(
      loading: () => const ShimmerList(itemCount: 6, itemHeight: 72, showTrailing: true),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FailureWidget(
            title: 'Unable to load leaderboard',
            message: 'Check your connection and try again.',
            onRetry: () => ref.invalidate(leaderboardProvider),
          ),
        ),
      ),
      data: (users) {
        if (users.isEmpty) {
          return const Center(
            child: Text(
              'No leaderboard entries yet',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          );
        }

        final entries = List.generate(users.length, (i) {
          final u = users[i];
          return LeaderboardEntry(
            rank: i + 1,
            name: u.username,
            avatarUrl: 'https://i.pravatar.cc/150?u=${u.id}',
            streakDays: u.streakCount,
            xp: u.streakCount * 100,
            rankDelta: 0,
            isCurrentUser: currentUser?.id == u.id,
          );
        });

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          itemCount: entries.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) => LeaderboardTile(entry: entries[i]),
        );
      },
    );
  }
}
