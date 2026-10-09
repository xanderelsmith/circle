import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../client.dart';

// Simulating a logged-in user for now since auth screens aren't built
final currentUserProvider = FutureProvider<User?>((ref) async {
  return await client.user.getCurrentUser();
});
