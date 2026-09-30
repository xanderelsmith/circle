enum LeaderboardPeriod { circle, weekly, monthly }

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.streakDays,
    required this.xp,
    required this.rankDelta,
    this.isCurrentUser = false,
  });

  final int rank;
  final String name;
  final String avatarUrl;
  final int streakDays;
  final int xp;
  final int rankDelta; // +up / -down / 0 flat
  final bool isCurrentUser;
}

class StreakSummary {
  const StreakSummary({
    required this.currentStreak,
    required this.rank,
    required this.xp,
    required this.xpGoal,
    required this.badgeLabel,
  });

  final int currentStreak;
  final int rank;
  final int xp;
  final int xpGoal;
  final String badgeLabel;

  double get progress => (xp / xpGoal).clamp(0.0, 1.0);
}

/// Formats 2480 → "2,480"
String formatXp(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
