import 'package:flutter/material.dart';
import 'package:circle_flutter/theme.dart';
import '../../domain/activity.dart';
import '.../../widgets/activity_header_card.dart';
import '.../../widgets/composer_bar.dart';
import '.../../widgets/thread_post_tile.dart';
import '../screens/add_proof_screen.dart';

class ActivityThreadScreen extends StatefulWidget {
  const ActivityThreadScreen({super.key, required this.activity});

  final Activity activity;

  @override
  State<ActivityThreadScreen> createState() => _ActivityThreadScreenState();
}

class _ActivityThreadScreenState extends State<ActivityThreadScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _commentController = TextEditingController();

  // Local mutable copy so newly posted proofs appear immediately.
  final List<ActivityPost> _posts = List.of(samplePosts);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

              // Composer — camera wired, send wired
              ComposerBar(
                controller: _commentController,
                onCameraTap: _openAddProof,
                onSend: () {
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                },
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
                                color: AppTheme.primaryBright
                                    .withValues(alpha: 0.35),
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
                        color: selected
                            ? Colors.white
                            : AppTheme.textSecondary,
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
    if (posts.isEmpty) {
      return const Center(
        child: Text(
          'No posts yet. Be the first!',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
        ),
      );
    }
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

class _MembersTab extends StatelessWidget {
  const _MembersTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
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
                  'https://i.pravatar.cc/100?img=${10 + i}',
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
                      'Member ${i + 1}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(i + 1) * 5} day streak',
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
  }
}

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Activity leaderboard',
        style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
      ),
    );
  }
}