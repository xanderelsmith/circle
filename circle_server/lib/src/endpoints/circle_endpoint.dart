import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class CircleEndpoint extends Endpoint {
  
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
      orderBy: (t) => t.createdAt,
      orderDescending: true,
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
