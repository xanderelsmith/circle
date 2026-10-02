import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  
  // Post a message
  Future<ChatMessage> postMessage(Session session, ChatMessage message) async {
    message.createdAt = DateTime.now();
    final savedMessage = await ChatMessage.db.insertRow(session, message);
    
    // Broadcast the message to a channel for the group
    session.messages.postMessage('chat_\', savedMessage);
    
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
  
  // Real-time stream handling
  @override
  Future<void> streamOpened(StreamingSession session) async {
    // When a client opens a stream, they can start listening to channels
  }
  
  @override
  Future<void> handleStreamMessage(StreamingSession session, SerializableEntity message) async {
    // Handle incoming streaming messages if needed
  }
}
