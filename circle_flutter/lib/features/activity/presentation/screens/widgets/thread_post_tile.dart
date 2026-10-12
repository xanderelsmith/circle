import 'dart:io';
import 'package:flutter/material.dart';
import 'package:circle_flutter/theme.dart';
import '../../../domain/activity.dart';

class ThreadPostTile extends StatelessWidget {
  const ThreadPostTile({
    super.key,
    required this.post,
    required this.isFirst,
    required this.isLast,
  });

  final ActivityPost post;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------- Timeline column ----------
          SizedBox(
            width: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 14),
                // Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                    border: Border.all(
                      color: AppTheme.background,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBright.withValues(alpha: 0.55),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppTheme.primaryBright.withValues(alpha: 0.25),
                    ),
                  ),
              ],
            ),
          ),

          // ---------- Post content ----------
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isFirst ? 12 : 20,
                bottom: 8,
              ),
              child: _PostBody(post: post),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({required this.post});

  final ActivityPost post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Header: avatar, name, time, menu ----------
        Row(
          children: [
            ClipOval(
              child: Image.network(
                post.authorAvatarUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 36,
                  height: 36,
                  color: AppTheme.surfaceLight,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.person,
                    size: 18,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          post.authorName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (post.isAuthorCrowned) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.workspace_premium,
                          size: 14,
                          color: AppTheme.gold,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post.timeAgo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 20,
                color: AppTheme.textMuted,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ---------- Image / video with badge ----------
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 11,
            child: Stack(
              children: [
                Positioned.fill(child: _imageFor(post.imageUrl)),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      post.imageBadge,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ---------- Caption ----------
        Text(
          post.caption,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textPrimary,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 10),

        // ---------- Reaction row ----------
        _ReactionRow(post: post),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Media resolver: handles remote URLs, local image files, and local videos
  // ---------------------------------------------------------------------------
  Widget _imageFor(String url) {
    if (url.isEmpty) {
      return Container(
        color: AppTheme.surfaceLight,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textMuted,
          size: 40,
        ),
      );
    }

    final isRemote = url.startsWith('http://') || url.startsWith('https://');
    if (isRemote) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: AppTheme.surfaceLight,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            color: AppTheme.textMuted,
            size: 40,
          ),
        ),
      );
    }

    // Local file — detect video by extension
    final lower = url.toLowerCase();
    final isVideo =
        lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv');

    if (isVideo) {
      return Container(
        color: Colors.black.withValues(alpha: 0.65),
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_fill_rounded,
          size: 52,
          color: Colors.white,
        ),
      );
    }

    return Image.file(
      File(url),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: AppTheme.surfaceLight,
        alignment: Alignment.center,
        child: const Icon(
          Icons.broken_image_outlined,
          color: AppTheme.textMuted,
          size: 40,
        ),
      ),
    );
  }
}

// =============================================================================
// Reaction row
// =============================================================================
class _ReactionRow extends StatelessWidget {
  const _ReactionRow({required this.post});

  final ActivityPost post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ReactionChip(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppTheme.fire,
          count: '${post.fireCount}',
          selected: false,
        ),
        const SizedBox(width: 8),
        _ReactionChip(
          icon: Icons.favorite_rounded,
          iconColor: const Color(0xFFB388FF),
          label: 'Respect',
          selected: post.respectedByMe,
        ),
        const SizedBox(width: 8),
        _ReactionChip(
          icon: Icons.bolt_rounded,
          iconColor: AppTheme.cyan,
          label: 'Push me',
          selected: post.pushedByMe,
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(
              Icons.mode_comment_outlined,
              size: 15,
              color: AppTheme.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              '${post.commentCount}',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.icon,
    required this.iconColor,
    this.label,
    this.count,
    required this.selected,
  });

  final IconData icon;
  final Color iconColor;
  final String? label;
  final String? count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: selected
            ? iconColor.withValues(alpha: 0.15)
            : const Color(0xFF0B1224),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? iconColor.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 4),
          if (label != null)
            Text(
              label!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            )
          else
            Text(
              count ?? '',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
