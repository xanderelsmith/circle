import 'package:serverpod/serverpod.dart';
import '../generated/device_token.dart';
import '../services/fcm_service.dart';

class NotificationEndpoint extends Endpoint {
  // Get authenticated user ID from session
  int? _getUserId(Session session) {
    // In Serverpod 4.x, session has userId when authenticated
    // Using dynamic to bypass static analysis
    return (session as dynamic).userId as int?;
  }

  // Register a device token for push notifications
  Future<bool> registerDeviceToken(
    Session session,
    String token,
    String platform,
  ) async {
    final userId = _getUserId(session);
    if (userId == null) return false;

    try {
      // Check if token already exists for this user/platform
      final existing = await DeviceToken.db.findFirstRow(
        session,
        where: (t) =>
            t.userId.equals(userId) & t.platform.equals(platform),
      );

      if (existing != null) {
        // Update existing token
        existing.token = token;
        existing.createdAt = DateTime.now();
        await DeviceToken.db.updateRow(session, existing);
      } else {
        // Insert new token
        await DeviceToken.db.insertRow(
          session,
          DeviceToken(
            userId: userId,
            token: token,
            platform: platform,
            createdAt: DateTime.now(),
          ),
        );
      }

      // Subscribe to all_users topic
      await FCMService.instance.subscribeToTopic(
        tokens: [token],
        topic: 'all_users',
      );

      return true;
    } catch (e) {
      print('Error registering device token: $e');
      return false;
    }
  }

  // Unregister a device token
  Future<bool> unregisterDeviceToken(
    Session session,
    String token,
  ) async {
    try {
      // Get user ID before deleting
      final tokenRow = await DeviceToken.db.findFirstRow(
        session,
        where: (t) => t.token.equals(token),
      );
      final userId = tokenRow?.userId;

      await DeviceToken.db.deleteWhere(
        session,
        where: (t) => t.token.equals(token),
      );

      if (userId != null) {
        // Unsubscribe from all_users topic
        await FCMService.instance.unsubscribeFromTopic(
          tokens: [token],
          topic: 'all_users',
        );
      }
      return true;
    } catch (e) {
      print('Error unregistering device token: $e');
      return false;
    }
  }

  // Send notification to a specific user
  Future<bool> sendNotification(
    Session session,
    int userId,
    String title,
    String body,
    Map<String, String>? data,
  ) async {
    return await FCMService.instance.sendToUser(
      session: session,
      userId: userId,
      title: title,
      body: body,
      data: data,
    );
  }

  // Send notification to a topic
  Future<bool> sendTopicNotification(
    Session session,
    String topic,
    String title,
    String body,
    Map<String, String>? data,
  ) async {
    return await FCMService.instance.sendToTopic(
      topic: topic,
      title: title,
      body: body,
      data: data,
    );
  }

  // Subscribe user to a circle topic
  Future<bool> subscribeToCircle(
    Session session,
    int circleId,
  ) async {
    final userId = _getUserId(session);
    if (userId == null) return false;

    try {
      final tokens = await DeviceToken.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (tokens.isEmpty) return false;

      final tokenList = tokens.map((t) => t.token).toList();
      await FCMService.instance.subscribeToTopic(
        tokens: tokenList,
        topic: 'circle_$circleId',
      );
      return true;
    } catch (e) {
      print('Error subscribing to circle topic: $e');
      return false;
    }
  }

  // Unsubscribe user from a circle topic
  Future<bool> unsubscribeFromCircle(
    Session session,
    int circleId,
  ) async {
    final userId = _getUserId(session);
    if (userId == null) return false;

    try {
      final tokens = await DeviceToken.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      if (tokens.isEmpty) return false;

      final tokenList = tokens.map((t) => t.token).toList();
      await FCMService.instance.unsubscribeFromTopic(
        tokens: tokenList,
        topic: 'circle_$circleId',
      );
      return true;
    } catch (e) {
      print('Error unsubscribing from circle topic: $e');
      return false;
    }
  }
}