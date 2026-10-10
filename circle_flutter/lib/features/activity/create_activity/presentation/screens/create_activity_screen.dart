import 'package:flutter/material.dart';
import 'package:circle_flutter/theme.dart';
import 'package:circle_flutter/features/activity/domain/activity.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({super.key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ActivityType _type = ActivityType.habit;
  DurationOption _duration = DurationOption.thirtyDays;
  ProofRequirement _proof = ProofRequirement.photo;
  VisibilityScope _visibility = VisibilityScope.public;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Date pickers
  // ---------------------------------------------------------------------------
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now.add(const Duration(days: 7)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: isStart ? now.subtract(const Duration(days: 365)) : initial,
      lastDate: now.add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryBright,
              onPrimary: Colors.white,
              surface: Color(0xFF0B1224),
              onSurface: AppTheme.textPrimary,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF0B1224),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked.add(const Duration(days: 7));
        }
      } else {
        _endDate = picked;
      }
    });
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------
  void _handleCreate() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showSnack('Please enter an activity title', isError: true);
      return;
    }

    if (_duration == DurationOption.custom) {
      if (_startDate == null || _endDate == null) {
        _showSnack('Please pick a start and end date', isError: true);
        return;
      }
    }

    final newActivity = Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: _descriptionController.text.trim(),
      type: _type,
      duration: _duration,
      proofRequirement: _proof,
      visibility: _visibility,
      iconEmoji: _emojiForType(_type),
      memberCount: 1,
      isJoined: true,
      currentDay: 0,
      totalDays: _computeTotalDays(),
    );

    // Pops with the new Activity so the caller can act on it.
    Navigator.of(context).pop(newActivity);
  }

  int _computeTotalDays() {
    switch (_duration) {
      case DurationOption.sevenDays:
        return 7;
      case DurationOption.thirtyDays:
        return 30;
      case DurationOption.custom:
        if (_startDate != null && _endDate != null) {
          return _endDate!.difference(_startDate!).inDays.clamp(1, 3650);
        }
        return 30;
    }
  }

  String _emojiForType(ActivityType type) {
    switch (type) {
      case ActivityType.habit:
        return '🔥';
      case ActivityType.challenge:
        return '📖';
      case ActivityType.groupActivity:
        return '👥';
    }
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? AppTheme.danger : AppTheme.primaryBright,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _CreateHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    // ---------- Title ----------
                    _FieldLabel(
                      label: 'Activity Title',
                      counter: '${_titleController.text.length}/60',
                    ),
                    const SizedBox(height: 8),
                    _DarkTextField(
                      controller: _titleController,
                      hint: 'e.g. 30 Day Reading Challenge',
                      maxLength: 60,
                    ),
                    const SizedBox(height: 22),

                    // ---------- Description ----------
                    _FieldLabel(
                      label: 'Description',
                      optional: true,
                      counter: '${_descriptionController.text.length}/200',
                      counterBelow: true,
                    ),
                    const SizedBox(height: 8),
                    _DarkTextField(
                      controller: _descriptionController,
                      hint: 'What is this activity about?',
                      maxLines: 4,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 22),

                    // ---------- Activity Type ----------
                    const _SectionLabel('Activity Type'),
                    const SizedBox(height: 10),
                    Row(
                      children: ActivityType.values.map((t) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  t == ActivityType.groupActivity ? 0 : 8,
                            ),
                            child: _TypeChip(
                              label: labelForType(t),
                              icon: iconForType(t),
                              selected: _type == t,
                              onTap: () => setState(() => _type = t),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // ---------- Duration ----------
                    const _SectionLabel('Duration'),
                    const SizedBox(height: 10),
                    Row(
                      children: DurationOption.values.map((d) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: d == DurationOption.custom ? 0 : 8,
                            ),
                            child: _SimpleChip(
                              label: labelForDuration(d),
                              icon: d == DurationOption.custom
                                  ? Icons.calendar_today_outlined
                                  : null,
                              selected: _duration == d,
                              onTap: () => setState(() => _duration = d),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // ---------- Custom date range ----------
                    AnimatedSize(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: _duration == DurationOption.custom
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: _CustomDateRange(
                                startDate: _startDate,
                                endDate: _endDate,
                                formatDate: _formatDate,
                                onPickStart: () =>
                                    _pickDate(isStart: true),
                                onPickEnd: () => _pickDate(isStart: false),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 22),

                    // ---------- Proof Requirement ----------
                    const _SectionLabel('Proof Requirement'),
                    const SizedBox(height: 10),
                    Row(
                      children: ProofRequirement.values.map((p) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: p == ProofRequirement.any ? 0 : 8,
                            ),
                            child: _ProofTile(
                              label: labelForProof(p),
                              icon: iconForProof(p),
                              selected: _proof == p,
                              onTap: () => setState(() => _proof = p),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // ---------- Proof Preview ----------
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _ProofPreview(
                        key: ValueKey(_proof),
                        proof: _proof,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // ---------- Visibility ----------
                    const _SectionLabel('Visibility'),
                    const SizedBox(height: 10),
                    Row(
                      children: VisibilityScope.values.map((v) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  v == VisibilityScope.onlyInCircle ? 0 : 10,
                            ),
                            child: _VisibilityTile(
                              label: labelForVisibility(v),
                              icon: iconForVisibility(v),
                              selected: _visibility == v,
                              onTap: () =>
                                  setState(() => _visibility = v),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),

                    // ---------- Cover Image ----------
                    const _SectionLabel(
                      'Add Cover Image',
                      optional: true,
                    ),
                    const SizedBox(height: 10),
                    _CoverImagePicker(onTap: () {}),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
              _CreateButton(onPressed: _handleCreate),
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
class _CreateHeader extends StatelessWidget {
  const _CreateHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
            color: AppTheme.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Activity',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Start a challenge, habit or group activity and get your circle involved.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const _SparkleBadge(),
        ],
      ),
    );
  }
}

class _SparkleBadge extends StatelessWidget {
  const _SparkleBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.primaryBright.withValues(alpha: 0.45),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.auto_awesome,
              size: 26, color: AppTheme.primaryBright),
          Positioned(
            top: 6,
            right: 8,
            child: Icon(Icons.star, size: 10, color: AppTheme.cyan),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Icon(Icons.star, size: 8, color: AppTheme.accent),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Field label
// =============================================================================
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    this.counter,
    this.optional = false,
    this.counterBelow = false,
  });

  final String label;
  final String? counter;
  final bool optional;
  final bool counterBelow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          const Text(
            '(Optional)',
            style: TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
          ),
        ],
        const Spacer(),
        if (counter != null && !counterBelow)
          Text(
            counter!,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppTheme.textMuted,
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// Section label
// =============================================================================
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.optional = false});

  final String text;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          const Text(
            '(Optional)',
            style: TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// Dark text field
// =============================================================================
class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        fontSize: 14,
        color: AppTheme.textPrimary,
        height: 1.4,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
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
    );
  }
}

// =============================================================================
// Custom date range
// =============================================================================
class _CustomDateRange extends StatelessWidget {
  const _CustomDateRange({
    required this.startDate,
    required this.endDate,
    required this.formatDate,
    required this.onPickStart,
    required this.onPickEnd,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final String Function(DateTime) formatDate;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateField(
            label: 'Start Date',
            value: startDate == null ? null : formatDate(startDate!),
            icon: Icons.calendar_today_outlined,
            onTap: onPickStart,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DateField(
            label: 'End Date',
            value: endDate == null ? null : formatDate(endDate!),
            icon: Icons.event_available_outlined,
            onTap: onPickEnd,
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1224),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: filled
                ? AppTheme.primaryBright.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.06),
            width: filled ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: filled ? AppTheme.primaryBright : AppTheme.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? 'Tap to pick',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: filled
                          ? AppTheme.textPrimary
                          : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Type chip
// =============================================================================
class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
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
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
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
// Simple chip
// =============================================================================
class _SimpleChip extends StatelessWidget {
  const _SimpleChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1224),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppTheme.primaryBright
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBright.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected
                    ? AppTheme.primaryBright
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color:
                    selected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Proof tile
// =============================================================================
class _ProofTile extends StatelessWidget {
  const _ProofTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 74,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1224),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppTheme.primaryBright
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBright.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  selected ? AppTheme.primaryBright : AppTheme.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color:
                    selected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Proof preview
// =============================================================================
class _ProofPreview extends StatelessWidget {
  const _ProofPreview({super.key, required this.proof});

  final ProofRequirement proof;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1224),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBright.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 13,
                color: AppTheme.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'PREVIEW · ${labelForProof(proof).toUpperCase()} PROOF',
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (proof) {
      case ProofRequirement.photo:
        return _MediaPreview(
          icon: Icons.camera_alt_rounded,
          title: 'Take a photo',
          subtitle: 'Capture proof of today',
          gradientColors: const [Color(0xFF7B4DFF), Color(0xFF3D7BFF)],
        );

      case ProofRequirement.video:
        return _MediaPreview(
          icon: Icons.videocam_rounded,
          title: 'Record a video',
          subtitle: 'Up to 60 seconds',
          gradientColors: const [Color(0xFF9B5CFF), Color(0xFF7B4DFF)],
        );

      case ProofRequirement.text:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF050A16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Write your proof...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              SizedBox(height: 10),
              Divider(height: 1, color: Color(0x14FFFFFF)),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Text(
                    '0/280',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case ProofRequirement.any:
        return Row(
          children: [
            Expanded(
              child: _MiniProofOption(
                icon: Icons.camera_alt_rounded,
                label: 'Photo',
                gradientColors: const [
                  Color(0xFF7B4DFF),
                  Color(0xFF3D7BFF),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniProofOption(
                icon: Icons.videocam_rounded,
                label: 'Video',
                gradientColors: const [
                  Color(0xFF9B5CFF),
                  Color(0xFF7B4DFF),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniProofOption(
                icon: Icons.description_rounded,
                label: 'Text',
                gradientColors: const [
                  Color(0xFF42D9FF),
                  Color(0xFF3D7BFF),
                ],
              ),
            ),
          ],
        );
    }
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientColors[0].withValues(alpha: 0.18),
            gradientColors[1].withValues(alpha: 0.10),
          ],
        ),
        border: Border.all(
          color: gradientColors[0].withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniProofOption extends StatelessWidget {
  const _MiniProofOption({
    required this.icon,
    required this.label,
    required this.gradientColors,
  });

  final IconData icon;
  final String label;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF050A16),
        border: Border.all(
          color: gradientColors[0].withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: gradientColors[0]),
          const SizedBox(height: 6),
          Text(
            label,
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

// =============================================================================
// Visibility tile
// =============================================================================
class _VisibilityTile extends StatelessWidget {
  const _VisibilityTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF0B1224),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppTheme.primaryBright
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBright.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  selected ? AppTheme.primaryBright : AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    selected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Cover image picker
// =============================================================================
class _CoverImagePicker extends StatelessWidget {
  const _CoverImagePicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF0B1224),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 20,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap to add a cover photo',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'or choose from gallery',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Create button
// =============================================================================
class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onPressed});

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
              'Create Activity',
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