import 'package:circle_client/circle_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../client.dart';

class AuthController extends Notifier<User?> {
  Future<void> signUp(String username, String phoneNumber) async {
    try {
      final user = await client.user.signUp(username, phoneNumber);
      state = user;
    } catch (_) {
      // Allow error handling in caller
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    if (state != null) return state;
    try {
      final user = await client.user.getCurrentUser();
      state = user;
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<void> assignUser(User user) async {
    state = user;
  }

  @override
  User? build() {
    return null;
  }
}

final authControllerProvider = NotifierProvider<AuthController, User?>(
  AuthController.new,
);
