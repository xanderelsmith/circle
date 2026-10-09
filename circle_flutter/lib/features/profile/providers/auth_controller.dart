import 'package:circle_client/circle_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends Notifier<User?> {
  Future<void> signUp(String username, String phoneNumber) async {
    // Implementation for signing up a new user
  }

  Future<User?> getCurrentUser() async {
    return state;
  }

  Future<void> assignUser(User user) async {
    state = user;
  }

  @override
  User? build() {
    return null;
  }
}
