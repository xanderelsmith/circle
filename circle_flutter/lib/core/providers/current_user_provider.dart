import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../client.dart';
import 'auth_provider.dart';

// Current user provider - now syncs with auth state
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  // If not authenticated, return null immediately
  if (authState != AuthState.authenticated) {
    return null;
  }
  
  try {
    return await client.user.getCurrentUser();
  } catch (e) {
    // If call fails, user might not be authenticated
    return null;
  }
});
