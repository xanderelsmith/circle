import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../../../../core/widgets/circle_logo.dart';
import '../../domain/leaderboard_entry.dart';
import '../../widgets/leaderboard_tile.dart';
import '../../widgets/segmented_pill_bar.dart';
import '../../widgets/streak_hero_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  LeaderboardPeriod _period = LeaderboardPeriod.circle;

  static const _me = StreakSummary(
    currentStreak: 18,
    rank: 3,
    xp: 2480,
    xpGoal: 4000,
    badgeLabel: 'Top 3 in your circle',
  );

  static const _entries = <LeaderboardEntry>[
    LeaderboardEntry(
      rank: 1,
      name: 'Sarah',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      streakDays: 26,
      xp: 3420,
      rankDelta: 2,
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'David',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      streakDays: 21,
      xp: 2980,
      rankDelta: 1,
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Emmanuel',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      streakDays: 18,
      xp: 2480,
      rankDelta: 0,
      isCurrentUser: true,
    ),
    LeaderboardEntry(
      rank: 4,
      name: 'John',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      streakDays: 12,
      xp: 1920,
      rankDelta: 1,
    ),
    LeaderboardEntry(
      rank: 5,
      name: 'Chisom',
      avatarUrl: 'https://i.pravatar.cc/150?img=45',
      streakDays: 11,
      xp: 1760,
      rankDelta: -1,
    ),
    LeaderboardEntry(
      rank: 6,
      name: 'Kelvin',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
      streakDays: 9,
      xp: 1430,
      rankDelta: 0,
    ),
    LeaderboardEntry(
      rank: 7,
      name: 'Blessing',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      streakDays: 7,
      xp: 1120,
      rankDelta: 1,
    ),
    LeaderboardEntry(
      rank: 8,
      name: 'Tobi',
      avatarUrl: 'https://i.pravatar.cc/150?img=59',
      streakDays: 5,
      xp: 980,
      rankDelta: -1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppTheme.primaryBright,
          backgroundColor: AppTheme.surfaceLight,
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 600));
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              const SliverToBoxAdapter(child: _LeaderboardHeader()),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: StreakHeroCard(summary: _me),
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

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: _entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => LeaderboardTile(entry: _entries[i]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Header — logo + "Circle / Stronger together." + notification bell
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
