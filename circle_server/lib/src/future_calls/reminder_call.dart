import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ReminderCall extends FutureCall<User> {
  Future<void> invoke(Session session, User? user) async {
    if (user == null) return;
    
    final phoneNumber = user.phoneNumber;
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    // Check if user has any habits due soon or at risk
    final now = DateTime.now();
    final userId = user.id!;

    // Get user's active circles/activities
    final circleIds = await _getUserCircleIds(session, userId);
    if (circleIds.isEmpty) return;

    final circles = await CircleGroup.db.find(
      session,
      where: (t) => t.id.inSet(circleIds.toSet()),
    );

    for (final circle in circles) {
      final deadline = circle.dailyDeadline;
      final hoursUntilDeadline = deadline.difference(now).inHours;

      // Trigger reminder if deadline is within 2 hours
      if (hoursUntilDeadline >= 0 && hoursUntilDeadline <= 2) {
        await _triggerReminderCall(
          session,
          phoneNumber,
          circle.name,
          'deadline',
          hoursUntilDeadline,
        );
      }

      // Check streak at risk (no proof posted today)
      final startOfToday = DateTime(now.year, now.month, now.day);
      final todayProofs = await ProofPost.db.find(
        session,
        where: (t) =>
            t.userId.equals(userId) &
            t.circleId.equals(circle.id!) &
            (t.createdAt >= startOfToday),
      );

      if (todayProofs.isEmpty && user.streakCount > 0) {
        await _triggerReminderCall(
          session,
          phoneNumber,
          circle.name,
          'streak_at_risk',
          0,
        );
      }
    }
  }

  Future<List<int>> _getUserCircleIds(Session session, int userId) async {
    // Get circle IDs where user has posted proofs
    final posts = await ProofPost.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return posts.map((p) => p.circleId).toSet().toList();
  }

  Future<void> _triggerReminderCall(
    Session session,
    String phoneNumber,
    String circleName,
    String type,
    int hoursUntilDeadline,
  ) async {
    final vapiKey = Platform.environment['VAPI_PRIVATE_KEY'] ?? 'YOUR_VAPI_PRIVATE_KEY';
    final url = Uri.parse('https://api.vapi.ai/call/phone');

    String message;
    switch (type) {
      case 'deadline':
        message = 'Hey! Your $circleName deadline is in $hoursUntilDeadline hour${hoursUntilDeadline == 1 ? '' : 's'}. Time to post your proof!';
        break;
      case 'streak_at_risk':
        message = 'Your $circleName streak is at risk! You haven\'t posted proof today. Don\'t lose your streak!';
        break;
      default:
        message = 'Time for your $circleName habit!';
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $vapiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'assistant': {
            'firstMessage': message,
            'model': {
              'provider': 'openai',
              'model': 'gpt-4o-mini',
            },
            'voice': {
              'provider': '11labs',
              'voiceId': 'drill_sergeant_voice_id',
            },
          },
          'customer': {
            'number': phoneNumber,
          },
        }),
      );

      if (response.statusCode == 201) {
        // Use dynamic to access userId getter
        final sessionUserId = (session as dynamic).userId;
        session.log('Reminder call triggered for user $sessionUserId ($type)');
      } else {
        session.log('Failed to trigger reminder call: ${response.body}');
      }
    } catch (e) {
      session.log('Error triggering reminder call: $e');
    }
  }
}