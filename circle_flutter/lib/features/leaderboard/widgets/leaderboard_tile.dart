import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../domain/leaderboard_entry.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({super.key, required this.entry});

  final LeaderboardEntry entry;

  Color? get _accent => switch (entry.rank) {
    1 => AppTheme.gold,
    2 => AppTheme.textSecondary,
    3 => const Color(0xFFCD7F32),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final accent = _accent;
    final isMe = entry.isCurrentUser;

    final Color borderColor = isMe
        ? AppTheme.primaryBright.withValues(alpha: 0.75)
        : accent != null
        ? accent.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.05);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isMe
            ? AppTheme.primaryBright.withValues(alpha: 0.10)
            : AppTheme.card,
        border: Border.all(
          color: borderColor,
          width: (isMe || accent != null) ? 1.4 : 1,
        ),
        boxShadow: isMe
            ? [
                BoxShadow(
                  color: AppTheme.primaryBright.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          _RankBadge(rank: entry.rank, accent: accent),
          const SizedBox(width: 12),
          _Avatar(
            url: entry.avatarUrl,
            accent: accent,
            isMe: isMe,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (entry.rank == 1) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.workspace_premium,
                        size: 15,
                        color: AppTheme.gold,
                      ),
                    ],
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      const _YouChip(),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 13,
                      color: AppTheme.fire,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.streakDays} day streak',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${formatXp(entry.xp)} XP',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 5),
              _DeltaIndicator(delta: entry.rankDelta),
            ],
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.white.withValues(alpha: 0.20),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank, required this.accent});

  final int rank;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    if (accent == null) {
      return SizedBox(
        width: 28,
        child: Text(
          '$rank',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textMuted,
          ),
        ),
      );
    }

    final onColor = rank == 3 ? Colors.white : const Color(0xFF1A1206);

    return Container(
      width: 28,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent!.withValues(alpha: 1.0),
            accent!.withValues(alpha: 0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: accent!.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '$rank',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: onColor,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.url,
    required this.accent,
    required this.isMe,
  });

  final String url;
  final Color? accent;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final ring = accent != null || isMe;
    final ringColors = accent != null
        ? [accent!, accent!.withValues(alpha: 0.4)]
        : [AppTheme.primaryBright, AppTheme.cyan];

    return Container(
      width: 44,
      height: 44,
      padding: EdgeInsets.all(ring ? 2 : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ring
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ringColors,
              )
            : null,
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: AppTheme.surfaceLight,
            alignment: Alignment.center,
            child: const Icon(
              Icons.person,
              color: AppTheme.textMuted,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _YouChip extends StatelessWidget {
  const _YouChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'You',
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _DeltaIndicator extends StatelessWidget {
  const _DeltaIndicator({required this.delta});

  final int delta;

  @override
  Widget build(BuildContext context) {
    if (delta == 0) {
      return const Text(
        '—',
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.textMuted,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    final up = delta > 0;
    final color = up ? AppTheme.success : AppTheme.danger;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: 16,
          color: color,
        ),
        Text(
          '${delta.abs()}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
