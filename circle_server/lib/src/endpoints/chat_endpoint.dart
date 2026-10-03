import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  
  // Post a message
  Future<ChatMessage> postMessage(Session session, ChatMessage message) async {
    message.createdAt = DateTime.now();
    final savedMessage = await ChatMessage.db.insertRow(session, message);
    
    // Broadcast the message to a channel for the group
    session.messages.postMessage('chat_${message.groupId}', savedMessage);
    
    return savedMessage;
  }

  // Get recent messages for a group
  Future<List<ChatMessage>> getMessages(Session session, int groupId) async {
    return await ChatMessage.db.find(
      session,
      where: (t) => t.groupId.equals(groupId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 100,
    );
  }
}
