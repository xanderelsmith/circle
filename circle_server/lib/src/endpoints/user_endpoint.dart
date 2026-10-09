import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  Future<User?> getCurrentUser(Session session) async {
    return User.db.findFirstRow(session);
  }

  // Create user
  Future<User> signUp(
    Session session,
    String username,
    String phoneNumber,
  ) async {
    return await createUser(session, username, phoneNumber);
  }

  Future<User> createUser(
    Session session,
    String username,
    String phoneNumber,
  ) async {
    var existingUser = await User.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(phoneNumber),
    );

    if (existingUser != null) {
      return existingUser;
    }

    var newUser = User(
      username: username,
      phoneNumber: phoneNumber,
      streakCount: 0,
      rankColor: 'Rookie',
    );

    return await User.db.insertRow(session, newUser);
  }

  // Get Leaderboard (sorted by streak)
  Future<List<User>> getLeaderboard(Session session) async {
    return await User.db.find(
      session,
      orderByList: (t) => [t.streakCount.desc()],
      limit: 50,
    );
  }
}
