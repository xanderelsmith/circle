import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../../client.dart'; // import the global 'client' object

final leaderboardProvider = FutureProvider<List<User>>((ref) async {
  // Call the serverpod endpoint
  return await client.user.getLeaderboard();
});
