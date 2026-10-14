import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the "last streak dialog shown" date so the congratulation
/// dialog fires at most once per calendar day.
class StreakService {
  StreakService._();
  static final StreakService instance = StreakService._();

  static const _storage = FlutterSecureStorage();
  static const _lastStreakKey = 'streak_last_shown_date';

  /// Returns true if today's streak dialog has NOT been shown yet.
  Future<bool> shouldShowStreakDialog() async {
    try {
      final stored = await _storage.read(key: _lastStreakKey);
      if (stored == null) return true;
      final lastShown = DateTime.tryParse(stored);
      if (lastShown == null) return true;
      final now = DateTime.now();
      return lastShown.year != now.year ||
          lastShown.month != now.month ||
          lastShown.day != now.day;
    } catch (_) {
      return false;
    }
  }

  /// Call after the dialog is shown so it won't show again today.
  Future<void> markStreakShown() async {
    try {
      await _storage.write(
        key: _lastStreakKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (_) {}
  }

  /// Shows the animated "🔥 Streak Day Added!" dialog.
  /// Safe to call from any screen; no-ops if already shown today.
  Future<void> maybeShowStreakDialog(
    BuildContext context, {
    required int streakCount,
  }) async {
    if (streakCount <= 0) return;
    final should = await shouldShowStreakDialog();
    if (!should) return;
    if (!context.mounted) return;

    await markStreakShown();

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _StreakDialog(streakCount: streakCount),
    );
  }
}

class _StreakDialog extends StatefulWidget {
  final int streakCount;
  const _StreakDialog({required this.streakCount});

  @override
  State<_StreakDialog> createState() => _StreakDialogState();
}

class _StreakDialogState extends State<_StreakDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streakLabel = _streakLabel(widget.streakCount);

    return FadeTransition(
      opacity: _fade,
      child: AlertDialog(
        backgroundColor: const Color(0xFF0D162B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: EdgeInsets.zero,
        content: ScaleTransition(
          scale: _scale,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated fire emoji
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.6, end: 1.0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut,
                  builder: (_, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: const Text('🔥', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Daily Streak Added!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'You\'re on a '),
                      TextSpan(
                        text: '${widget.streakCount}-day streak',
                        style: const TextStyle(
                          color: Color(0xFFFF8C00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: '.\n${''}'),
                      TextSpan(text: streakLabel),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Streak counter badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '🔥 ${widget.streakCount} Days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1B2339),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Keep it up! 💪',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _streakLabel(int days) {
    if (days >= 30) return 'Legendary commitment. Respect! 🏆';
    if (days >= 14) return 'Two weeks strong. You\'re on fire!';
    if (days >= 7) return 'A full week! Keep the momentum.';
    if (days >= 3) return 'Building a habit. Don\'t stop now!';
    return 'Every day counts. Show up again tomorrow!';
  }
}
