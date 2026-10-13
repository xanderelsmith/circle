import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/failure.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../theme.dart';
import '../../../../core/widgets/circle_logo.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../domain/leaderboard_entry.dart';
import '../../widgets/leaderboard_tile.dart';
import '../../widgets/segmented_pill_bar.dart';
import '../../widgets/streak_hero_card.dart';
import '../../data/leaderboard_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  LeaderboardPeriod _period = LeaderboardPeriod.circle;

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppTheme.primaryBright,
          backgroundColor: AppTheme.surfaceLight,
          onRefresh: () async {
            // ignore: unused_result
            ref.refresh(leaderboardProvider);
            return await ref.read(leaderboardProvider.future);
          },
          child: leaderboardAsync.when(
            loading: () => const ShimmerList(itemCount: 8, itemHeight: 72, showTrailing: true),
            error: (err, stack) => Center(
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
              final currentUser = currentUserAsync.value;

              // Map backend Users to LeaderboardEntry for the UI
              final entries = List.generate(users.length, (i) {
                final user = users[i];
                return LeaderboardEntry(
                  rank: i + 1,
                  name: user.username,
                  avatarUrl: 'https://i.pravatar.cc/150?u=${user.id}',
                  streakDays: user.streakCount,
                  xp: user.streakCount * 100, // Derived XP
                  rankDelta: 0,
                  isCurrentUser: currentUser?.id == user.id,
                );
              });

              StreakSummary? meSummary;
              if (currentUser != null) {
                final myIndex = entries.indexWhere((e) => e.isCurrentUser);
                if (myIndex != -1) {
                  final myEntry = entries[myIndex];
                  meSummary = StreakSummary(
                    currentStreak: myEntry.streakDays,
                    rank: myEntry.rank,
                    xp: myEntry.xp,
                    xpGoal: (myEntry.xp ~/ 1000 + 1) * 1000,
                    badgeLabel: 'Rank ${myEntry.rank} in your circle',
                  );
                }
              }

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  const SliverToBoxAdapter(child: _LeaderboardHeader()),

                  if (meSummary != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                        child: StreakHeroCard(summary: meSummary),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
                      child: SegmentedPillBar(
                        value: _period,
                        onChanged: (LeaderboardPeriod p) =>
                            setState(() => _period = p),
                      ),
                    ),
                  ),

                  if (entries.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No users in leaderboard yet',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList.separated(
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, i) =>
                            LeaderboardTile(entry: entries[i]),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header
// -----------------------------------------------------------------------------
class _LeaderboardHeader extends StatelessWidget {
  const _LeaderboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      child: Row(
        children: [
          const CircleLogo(size: 40),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                'Stronger together.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Badge(
              smallSize: 9,
              backgroundColor: AppTheme.danger,
              child: Icon(
                Icons.notifications_none,
                size: 28,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
