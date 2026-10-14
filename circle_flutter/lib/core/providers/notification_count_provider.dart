import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/data/home_feed_provider.dart';

/// Tracks the number of unread notifications.
///
/// Strategy: count is the total feed items across all circles.
/// When the user opens the Notifications screen the local count is cleared.
class NotificationCountNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int count) => state = count;
  void clear() => state = 0;
}

final notificationCountProvider =
    NotifierProvider<NotificationCountNotifier, int>(
      NotificationCountNotifier.new,
    );

/// Derives the badge count from the live feed so it updates automatically.
/// Each time the homeFeedProvider resolves, this pushes the new count into
/// the mutable [notificationCountProvider].
final feedNotificationSyncProvider = Provider<void>((ref) {
  final feedAsync = ref.watch(homeFeedProvider);
  feedAsync.whenData((posts) {
    // Use total post count as unread badge (resets when screen is visited)
    final currentCount = ref.read(notificationCountProvider);
    if (currentCount == 0 && posts.isNotEmpty) {
      ref.read(notificationCountProvider.notifier).set(posts.length);
    }
  });
});
