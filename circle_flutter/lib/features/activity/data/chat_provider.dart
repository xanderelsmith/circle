import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:circle_client/circle_client.dart';
import '../../../../client.dart';

/// Provider for fetching real chat messages for a specific group/circle ID
final groupChatMessagesProvider = FutureProvider.family<List<ChatMessage>, int>(
  (ref, groupId) async {
    try {
      return await client.chat.getMessages(groupId);
    } catch (e) {
      return [];
    }
  },
);
