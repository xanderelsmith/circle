import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../../client.dart';

/// Notifier to manage the currently selected circle ID
class SelectedCircleIdNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void selectCircle(int id) {
    state = id;
  }
}

final selectedCircleIdProvider =
    NotifierProvider<SelectedCircleIdNotifier, int>(
      SelectedCircleIdNotifier.new,
    );

/// Fetches all available circles from the Serverpod server
final circlesProvider = FutureProvider<List<CircleGroup>>((ref) async {
  return await client.circle.getCircles();
});

/// Fetches feed posts for the active circle.
/// Falls back to the first available circle if the selected ID yields nothing.
final homeFeedProvider = FutureProvider<List<ProofPost>>((ref) async {
  final circles = await ref.watch(circlesProvider.future);
  final selectedId = ref.watch(selectedCircleIdProvider);

  // If we have circles and the selected ID isn't among them, use the first one.
  int circleId = selectedId;
  if (circles.isNotEmpty) {
    final validIds = circles.map((c) => c.id).whereType<int>().toSet();
    if (!validIds.contains(selectedId)) {
      circleId = circles.first.id ?? selectedId;
      // Update the notifier so the rest of the app reflects the real ID.
      Future.microtask(
        () =>
            ref.read(selectedCircleIdProvider.notifier).selectCircle(circleId),
      );
    }
  }

  return await client.circle.getFeed(circleId);
});

/// Map of all users by ID for quick author lookup on feed posts
final usersMapProvider = FutureProvider<Map<int, User>>((ref) async {
  try {
    final list = await client.user.getLeaderboard();
    return {
      for (var u in list)
        if (u.id != null) u.id!: u,
    };
  } catch (_) {
    return {};
  }
});

/// Fetches feed posts across all circles for the 'For You' discovery tab
final forYouFeedProvider = FutureProvider<List<ProofPost>>((ref) async {
  final circles = await ref.watch(circlesProvider.future);
  final allPosts = <ProofPost>[];
  for (final c in circles) {
    if (c.id != null) {
      try {
        final posts = await client.circle.getFeed(c.id!);
        allPosts.addAll(posts);
      } catch (_) {}
    }
  }
  // Deduplicate by post id and sort newest first
  final seen = <int>{};
  final deduped = <ProofPost>[];
  for (final p in allPosts) {
    if (p.id != null && seen.add(p.id!)) {
      deduped.add(p);
    } else if (p.id == null) {
      deduped.add(p);
    }
  }
  deduped.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return deduped;
});
