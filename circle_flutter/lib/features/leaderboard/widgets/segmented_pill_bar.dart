import 'package:flutter/material.dart';
import '../../../../theme.dart';
import '../domain/leaderboard_entry.dart';

class SegmentedPillBar extends StatelessWidget {
  const SegmentedPillBar({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final LeaderboardPeriod value;
  final ValueChanged<LeaderboardPeriod> onChanged;

  static const _labels = {
    LeaderboardPeriod.circle: 'Circle Leaderboard',
    LeaderboardPeriod.weekly: 'Weekly',
    LeaderboardPeriod.monthly: 'Monthly',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: _labels.entries.map((e) {
          final selected = e.key == value;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: selected ? AppTheme.primaryGradient : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBright.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  e.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
