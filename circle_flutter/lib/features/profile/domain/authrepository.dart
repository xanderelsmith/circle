import 'package:circle_client/circle_client.dart';

class AuthRepository {
  final Client client;
  AuthRepository({required this.client});
  Future<User> signUp(String name, String phone) async {
    return await client.user.signUp(name, phone);
  }

  Future<User?> getCurrentUser() async {
    // Simulating a logged-in user for now since auth screens aren't built
    return await client.user.getCurrentUser();
  }
}
