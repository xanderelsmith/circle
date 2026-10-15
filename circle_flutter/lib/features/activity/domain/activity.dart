import 'package:flutter/material.dart';

enum ActivityType { habit, challenge, groupActivity }

enum DurationOption { sevenDays, thirtyDays, custom }

enum ProofRequirement { photo, video, text, any }

enum VisibilityScope { public, onlyInCircle }

class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.proofRequirement,
    required this.visibility,
    required this.iconEmoji,
    required this.memberCount,
    required this.isJoined,
    required this.currentDay,
    required this.totalDays,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DurationOption duration;
  final ProofRequirement proofRequirement;
  final VisibilityScope visibility;
  final String iconEmoji;
  final int memberCount;
  final bool isJoined;
  final int currentDay;
  final int totalDays;
  final String? coverImageUrl;

  double get progress => (currentDay / totalDays).clamp(0.0, 1.0);
}

// Post
class ActivityPost {
  const ActivityPost({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.timeAgo,
    required this.imageUrl,
    required this.imageBadge,
    required this.caption,
    required this.fireCount,
    required this.respectCount,
    required this.pushCount,
    required this.commentCount,
    this.isAuthorCrowned = false,
    this.respectedByMe = false,
    this.pushedByMe = false,
  });

  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String timeAgo;
  final String imageUrl;
  final String imageBadge;
  final String caption;
  final int fireCount;
  final int respectCount;
  final int pushCount;
  final int commentCount;
  final bool isAuthorCrowned;
  final bool respectedByMe;
  final bool pushedByMe;
}

const sampleActivity = Activity(
  id: 'a1',
  title: '30 Day Reading Challenge',
  description: 'Read 20 pages daily for 30 days',
  type: ActivityType.challenge,
  duration: DurationOption.thirtyDays,
  proofRequirement: ProofRequirement.photo,
  visibility: VisibilityScope.public,
  iconEmoji: '📖',
  memberCount: 12,
  isJoined: true,
  currentDay: 12,
  totalDays: 30,
);

const samplePosts = <ActivityPost>[
  ActivityPost(
    id: 'p1',
    authorName: 'Sarah',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=47',
    timeAgo: '2h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800&q=80',
    imageBadge: 'Page 45/20',
    caption: 'Page 45/20. Getting there! 📚',
    fireCount: 18,
    respectCount: 0,
    pushCount: 0,
    commentCount: 3,
    isAuthorCrowned: true,
  ),
  ActivityPost(
    id: 'p2',
    authorName: 'David',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=12',
    timeAgo: '4h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=800&q=80',
    imageBadge: 'Page 30/20',
    caption: 'Halfway through! 💪',
    fireCount: 12,
    respectCount: 0,
    pushCount: 0,
    commentCount: 1,
    respectedByMe: true,
  ),
  ActivityPost(
    id: 'p3',
    authorName: 'Alex',
    authorAvatarUrl: 'https://i.pravatar.cc/150?img=68',
    timeAgo: '6h ago',
    imageUrl:
        'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=800&q=80',
    imageBadge: 'Page 20/20',
    caption: 'Done for the day! ✅',
    fireCount: 25,
    respectCount: 0,
    pushCount: 0,
    commentCount: 5,
    pushedByMe: true,
  ),
];

// Helpers
String labelForType(ActivityType t) => switch (t) {
  ActivityType.habit => 'Habit',
  ActivityType.challenge => 'Challenge',
  ActivityType.groupActivity => 'Group Activity',
};

IconData iconForType(ActivityType t) => switch (t) {
  ActivityType.habit => Icons.bolt_rounded,
  ActivityType.challenge => Icons.emoji_events_outlined,
  ActivityType.groupActivity => Icons.groups_2_outlined,
};

String labelForDuration(DurationOption d) => switch (d) {
  DurationOption.sevenDays => '7 Days',
  DurationOption.thirtyDays => '30 Days',
  DurationOption.custom => 'Custom',
};

String labelForProof(ProofRequirement p) => switch (p) {
  ProofRequirement.photo => 'Photo',
  ProofRequirement.video => 'Video',
  ProofRequirement.text => 'Text',
  ProofRequirement.any => 'Any',
};

IconData iconForProof(ProofRequirement p) => switch (p) {
  ProofRequirement.photo => Icons.camera_alt_outlined,
  ProofRequirement.video => Icons.videocam_outlined,
  ProofRequirement.text => Icons.description_outlined,
  ProofRequirement.any => Icons.more_horiz_rounded,
};

String labelForVisibility(VisibilityScope v) => switch (v) {
  VisibilityScope.public => 'Public',
  VisibilityScope.onlyInCircle => 'Only in Circle',
};

IconData iconForVisibility(VisibilityScope v) => switch (v) {
  VisibilityScope.public => Icons.public_rounded,
  VisibilityScope.onlyInCircle => Icons.groups_outlined,
};
