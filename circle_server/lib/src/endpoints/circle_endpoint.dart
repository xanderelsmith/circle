import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class CircleEndpoint extends Endpoint {
  // Seed dummy data
  Future<bool> seedDummyData(Session session) async {
    // Check if we already seeded
    var existingUsers = await User.db.find(session, limit: 1);
    if (existingUsers.isNotEmpty) return false;

    // 1. Create a dummy circle
    var circle = await CircleGroup.db.insertRow(session, CircleGroup(
      name: 'Alpha Circle',
      dailyDeadline: DateTime.now().add(Duration(days: 1)),
    ));

    // 2. Create users
    var users = [
      User(username: 'Emmanuel', phoneNumber: '+1234567890', streakCount: 18, rankColor: 'Gold'),
      User(username: 'Sarah', phoneNumber: '+1234567891', streakCount: 7, rankColor: 'Silver'),
      User(username: 'Chioma', phoneNumber: '+1234567892', streakCount: 3, rankColor: 'Bronze'),
      User(username: 'David', phoneNumber: '+1234567893', streakCount: 11, rankColor: 'Silver'),
    ];
    
    var insertedUsers = await User.db.insert(session, users);

    // 3. Create proof posts for the feed
    var posts = [
      ProofPost(userId: insertedUsers[0].id!, circleId: circle.id!, imageUrl: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500&q=80', caption: 'Finally got it done. No excuses this time.', isVerified: true, createdAt: DateTime.now().subtract(Duration(hours: 2))),
      ProofPost(userId: insertedUsers[1].id!, circleId: circle.id!, imageUrl: 'https://images.unsplash.com/photo-1456324504439-367cee3b3c32?w=500&q=80', caption: 'Small steps, big dreams.', isVerified: true, createdAt: DateTime.now().subtract(Duration(hours: 4))),
      ProofPost(userId: insertedUsers[2].id!, circleId: circle.id!, imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&q=80', caption: 'Clean food, better mood.', isVerified: false, createdAt: DateTime.now().subtract(Duration(hours: 6))),
      ProofPost(userId: insertedUsers[3].id!, circleId: circle.id!, imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&q=80', caption: 'Leg day done', isVerified: true, createdAt: DateTime.now().subtract(Duration(hours: 5))),
    ];

    await ProofPost.db.insert(session, posts);
    return true;
  }
  
  // Fetch all circles for a user (placeholder implementation)
  Future<List<CircleGroup>> getCircles(Session session) async {
    return await CircleGroup.db.find(session);
  }

  // Create a new circle
  Future<CircleGroup> createCircle(Session session, CircleGroup circle) async {
    return await CircleGroup.db.insertRow(session, circle);
  }

  // Post a proof
  Future<ProofPost> createProofPost(Session session, ProofPost post) async {
    post.createdAt = DateTime.now();
    return await ProofPost.db.insertRow(session, post);
  }

  // Fetch feed for a circle
  Future<List<ProofPost>> getFeed(Session session, int circleId) async {
    return await ProofPost.db.find(
      session,
      where: (t) => t.circleId.equals(circleId),
      orderByList: (t) => [t.createdAt.desc()],
    );
  }

  // Verify a post
  Future<bool> verifyPost(Session session, int postId) async {
    var post = await ProofPost.db.findById(session, postId);
    if (post != null) {
      post.isVerified = true;
      await ProofPost.db.updateRow(session, post);
      return true;
    }
    return false;
  }
}




