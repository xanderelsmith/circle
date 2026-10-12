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

/// Fetches feed posts for the active circle
final homeFeedProvider = FutureProvider<List<ProofPost>>((ref) async {
  final circleId = ref.watch(selectedCircleIdProvider);
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
