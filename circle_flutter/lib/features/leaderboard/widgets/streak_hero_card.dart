import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../domain/leaderboard_entry.dart';

class StreakHeroCard extends StatelessWidget {
  const StreakHeroCard({super.key, required this.summary});

  final StreakSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppTheme.cardGradient,
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBright.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: _StreakBlock(summary: summary)),
          const SizedBox(width: 6),
          const SizedBox(width: 76, child: _CrownArt()),
          const SizedBox(width: 6),
          Container(
            width: 1,
            height: 78,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 4, child: _RankBlock(summary: summary)),
        ],
      ),
    );
  }
}

class _StreakBlock extends StatelessWidget {
  const _StreakBlock({required this.summary});
  final StreakSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: const [
            Icon(Icons.local_fire_department, size: 14, color: AppTheme.fire),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                'Your Current Streak',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${summary.currentStreak}',
                style: const TextStyle(
                  fontSize: 34,
                  height: 1,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const TextSpan(
                text: ' days',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.accent.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryBright.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.workspace_premium,
                size: 12,
                color: AppTheme.gold,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  summary.badgeLabel,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CrownArt extends StatelessWidget {
  const _CrownArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryBright.withValues(alpha: 0.45),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: -0.35,
            child: Container(
              width: 78,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: AppTheme.cyan.withValues(alpha: 0.55),
                  width: 1.4,
                ),
              ),
            ),
          ),
          const Text('👑', style: TextStyle(fontSize: 42)),
          Positioned(
            top: 6,
            right: 10,
            child: Icon(Icons.auto_awesome, size: 12, color: AppTheme.cyan),
          ),
          Positioned(
            bottom: 10,
            left: 4,
            child: Icon(Icons.auto_awesome, size: 9, color: AppTheme.accent),
          ),
        ],
      ),
    );
  }
}

class _RankBlock extends StatelessWidget {
  const _RankBlock({required this.summary});
  final StreakSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Your Rank',
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '#${summary.rank}',
          style: const TextStyle(
            fontSize: 26,
            height: 1,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatXp(summary.xp)} XP',
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Container(height: 6, color: AppTheme.surfaceLight),
              FractionallySizedBox(
                widthFactor: summary.progress,
                child: Container(
                  height: 6,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryBright, AppTheme.cyan],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
