import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../../client.dart';

final homeFeedProvider = FutureProvider<List<ProofPost>>((ref) async {
  // Use a dummy circle ID 1 for now
  return await client.circle.getFeed(1);
});
