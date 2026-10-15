import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circle_client/circle_client.dart';

import '../../../../client.dart';
import '../../../../core/providers/current_user_provider.dart';
import '../../../../theme.dart';
import '../../../home/data/home_feed_provider.dart';
import '../../domain/activity.dart';

enum _MediaKind { none, image, video }

class AddProofScreen extends ConsumerStatefulWidget {
  const AddProofScreen({super.key, required this.activity});

  final Activity activity;

  @override
  ConsumerState<AddProofScreen> createState() => _AddProofScreenState();
}

class _AddProofScreenState extends ConsumerState<AddProofScreen> {
  final _captionController = TextEditingController();
  final _picker = ImagePicker();

  XFile? _media;
  _MediaKind _kind = _MediaKind.none;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _captionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Pickers
  // ---------------------------------------------------------------------------
  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (file == null || !mounted) {
        setState(() => _isPicking = false);
        return;
      }
      setState(() {
        _media = file;
        _kind = _MediaKind.image;
        _isPicking = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isPicking = false);
        _showError('Could not pick image: $e');
      }
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      final file = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 60),
      );
      if (file == null || !mounted) {
        setState(() => _isPicking = false);
        return;
      }
      setState(() {
        _media = file;
        _kind = _MediaKind.video;
        _isPicking = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isPicking = false);
        _showError('Could not pick video: $e');
      }
    }
  }

  void _clearMedia() {
    setState(() {
      _media = null;
      _kind = _MediaKind.none;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------
  Future<void> _handlePost([User? user]) async {
    final requirement = widget.activity.proofRequirement;
    final caption = _captionController.text.trim();

    // Require media for photo/video/any.
    if (requirement != ProofRequirement.text && _kind == _MediaKind.none) {
      _showError('Add a ${labelForProof(requirement).toLowerCase()} first');
      return;
    }

    // Require text for text-only proofs.
    if (requirement == ProofRequirement.text && caption.isEmpty) {
      _showError('Write your proof first');
      return;
    }

    final currentUser = user ?? ref.read(currentUserProvider).value;
    final int circleId =
        int.tryParse(widget.activity.id) ?? ref.read(selectedCircleIdProvider);
    final imagePath = _media?.path.isNotEmpty == true
        ? _media!.path
        : 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500&q=80';

    final proofPost = ProofPost(
      userId: currentUser?.id ?? 1,
      circleId: circleId,
      imageUrl: imagePath,
      caption: caption.isEmpty ? 'Done for the day! ✅' : caption,
      isVerified: true,
      createdAt: DateTime.now(),
    );

    try {
      await client.circle.createProofPost(proofPost);
      ref.invalidate(homeFeedProvider);
      ref.invalidate(forYouFeedProvider);
    } catch (_) {
      // Continue so local preview works
    }

    final newPost = ActivityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: currentUser?.username ?? 'You',
      authorAvatarUrl: 'https://i.pravatar.cc/150?u=${currentUser?.id ?? 1}',
      timeAgo: 'Just now',
      // Local file path is used until backend upload is wired.
      imageUrl: _media?.path ?? '',
      imageBadge: _kind == _MediaKind.video ? 'Video · 60s max' : 'Photo proof',
      caption: caption.isEmpty ? 'Done for the day! ✅' : caption,
      fireCount: 0,
      respectCount: 0,
      pushCount: 0,
      commentCount: 0,
    );

    if (mounted) {
      Navigator.of(context).pop(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final requirement = widget.activity.proofRequirement;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _ProofHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 24 + bottomInset),
                  children: [
                    _ActivitySummaryCard(activity: widget.activity),
                    const SizedBox(height: 16),

                    // ---------- Media area ----------
                    if (requirement != ProofRequirement.text) ...[
                      _SourcePicker(
                        requirement: requirement,
                        isPicking: _isPicking,
                        onCameraPhoto: () => _pickImage(ImageSource.camera),
                        onGalleryPhoto: () => _pickImage(ImageSource.gallery),
                        onCameraVideo: () => _pickVideo(ImageSource.camera),
                        onGalleryVideo: () => _pickVideo(ImageSource.gallery),
                      ),
                      const SizedBox(height: 16),
                      _MediaPreview(
                        media: _media,
                        kind: _kind,
                        onClear: _clearMedia,
                        onReplace: _kind == _MediaKind.image
                            ? () => _pickImage(ImageSource.gallery)
                            : _kind == _MediaKind.video
                            ? () => _pickVideo(ImageSource.gallery)
                            : null,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ---------- Caption ----------
                    Row(
                      children: const [
                        Text(
                          'Add a caption',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(optional)',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _captionController,
                      maxLines: requirement == ProofRequirement.text ? 8 : 3,
                      maxLength: 200,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: requirement == ProofRequirement.text
                            ? 'Write your proof...'
                            : 'Say something about today...',
                        hintStyle: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFF0B1224),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryBright,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_captionController.text.length}/200',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ---------- Share to ----------
                    const Text(
                      'Share to',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ShareToRow(activity: widget.activity),
                  ],
                ),
              ),
              _PostButton(onPressed: () => _handlePost(currentUser)),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Header
// =============================================================================
class _ProofHeader extends StatelessWidget {
  const _ProofHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 24),
            color: AppTheme.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Your Proof',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Show your circle you're doing it!",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Activity summary card
// =============================================================================
class _ActivitySummaryCard extends StatelessWidget {
  const _ActivitySummaryCard({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1224),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBright.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              activity.iconEmoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activity.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.description.isEmpty
                      ? labelForType(activity.type)
                      : activity.description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              color: AppTheme.surfaceLight,
                            ),
                            FractionallySizedBox(
                              widthFactor: activity.progress,
                              child: Container(
                                height: 6,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryBright,
                                      AppTheme.cyan,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${activity.currentDay}/${activity.totalDays} days',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBright,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Source picker — Camera/Gallery buttons (or 2×2 for "any")
// =============================================================================
class _SourcePicker extends StatelessWidget {
  const _SourcePicker({
    required this.requirement,
    required this.isPicking,
    required this.onCameraPhoto,
    required this.onGalleryPhoto,
    required this.onCameraVideo,
    required this.onGalleryVideo,
  });

  final ProofRequirement requirement;
  final bool isPicking;
  final VoidCallback onCameraPhoto;
  final VoidCallback onGalleryPhoto;
  final VoidCallback onCameraVideo;
  final VoidCallback onGalleryVideo;

  @override
  Widget build(BuildContext context) {
    switch (requirement) {
      case ProofRequirement.photo:
        return Row(
          children: [
            Expanded(
              child: _SourceButton(
                label: 'Camera',
                icon: Icons.camera_alt_rounded,
                selected: true,
                busy: isPicking,
                onTap: onCameraPhoto,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SourceButton(
                label: 'Gallery',
                icon: Icons.image_outlined,
                selected: false,
                busy: isPicking,
                onTap: onGalleryPhoto,
              ),
            ),
          ],
        );

      case ProofRequirement.video:
        return Row(
          children: [
            Expanded(
              child: _SourceButton(
                label: 'Record',
                icon: Icons.videocam_rounded,
                selected: true,
                busy: isPicking,
                onTap: onCameraVideo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SourceButton(
                label: 'Library',
                icon: Icons.video_library_outlined,
                selected: false,
                busy: isPicking,
                onTap: onGalleryVideo,
              ),
            ),
          ],
        );

      case ProofRequirement.any:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    label: 'Camera Photo',
                    icon: Icons.camera_alt_rounded,
                    selected: true,
                    busy: isPicking,
                    onTap: onCameraPhoto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    label: 'Camera Video',
                    icon: Icons.videocam_rounded,
                    selected: true,
                    busy: isPicking,
                    onTap: onCameraVideo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    label: 'Gallery Photo',
                    icon: Icons.image_outlined,
                    selected: false,
                    busy: isPicking,
                    onTap: onGalleryPhoto,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    label: 'Gallery Video',
                    icon: Icons.video_library_outlined,
                    selected: false,
                    busy: isPicking,
                    onTap: onGalleryVideo,
                  ),
                ),
              ],
            ),
          ],
        );

      case ProofRequirement.text:
        return const SizedBox.shrink();
    }
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.busy,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF7B4DFF), Color(0xFF3D7BFF)],
                )
              : null,
          color: selected ? null : const Color(0xFF0B1224),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.06),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBright.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (busy)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : AppTheme.textSecondary,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Media preview — shows real picked image, or video card
// =============================================================================
class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    required this.media,
    required this.kind,
    required this.onClear,
    this.onReplace,
  });

  final XFile? media;
  final _MediaKind kind;
  final VoidCallback onClear;
  final VoidCallback? onReplace;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case _MediaKind.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(
                  File(media!.path),
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
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    _PillButton(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Replace',
                      onTap: onReplace,
                    ),
                    const SizedBox(width: 8),
                    _PillButton(
                      icon: Icons.close_rounded,
                      label: 'Remove',
                      onTap: onClear,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case _MediaKind.video:
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryBright.withValues(alpha: 0.30),
                AppTheme.cyan.withValues(alpha: 0.20),
              ],
            ),
            border: Border.all(
              color: AppTheme.primaryBright.withValues(alpha: 0.45),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBright.withValues(
                              alpha: 0.55,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Video ready',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        media!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    _PillButton(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Replace',
                      onTap: onReplace,
                    ),
                    const SizedBox(width: 8),
                    _PillButton(
                      icon: Icons.close_rounded,
                      label: 'Remove',
                      onTap: onClear,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case _MediaKind.none:
        return Container(
          height: 160,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF0B1224),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 42,
                color: AppTheme.textMuted.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your proof will appear here',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap Camera or Gallery to begin',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        );
    }
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Share-to row
// =============================================================================
class _ShareToRow extends StatelessWidget {
  const _ShareToRow({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1224),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
            ),
            child: Text(
              activity.iconEmoji,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppTheme.textMuted,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Post button
// =============================================================================
class _PostButton extends StatelessWidget {
  const _PostButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B4DFF), Color(0xFF3D7BFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBright.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Post Proof',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
