import 'package:flutter/material.dart';
import '../../../../theme.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // ---------------------------------------------------------------------------
  // Form state
  // ---------------------------------------------------------------------------
  String _selectedEmoji = '🔥';
  String _frequency = 'Daily';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String _selectedCircle = 'Personal';
  Color _selectedColor = AppTheme.primaryBright;
  bool _shareToCircle = true;
  bool _remindersEnabled = true;

  static const _emojis = <String>[
    '🔥', '💪', '📚', '🏃', '💧',
    '🧘', '🎯', '🍎', '🎨', '🧠',
  ];

  static const _frequencies = <String>[
    'Daily',
    'Weekdays',
    'Custom',
  ];

  static const _circles = <String>[
    'Personal',
    'Flutter Builders',
    'Fitness Bros',
    'Study Squad',
  ];

  static const _colors = <Color>[
    AppTheme.primaryBright, // Purple
    AppTheme.secondary,     // Blue
    AppTheme.cyan,          // Cyan
    AppTheme.success,       // Green
    AppTheme.warning,       // Orange
    AppTheme.danger,        // Red
    AppTheme.accent,        // Magenta-purple
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.surface,
              hourMinuteColor: AppTheme.surfaceLight,
              dialBackgroundColor: AppTheme.surfaceLight,
              dialHandColor: _selectedColor,
              entryModeIconColor: AppTheme.textSecondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  void _handleCreate() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a habit name'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // TODO: wire to your state management / backend later.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.atmosphericBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------------- Header ----------------
              _Header(onClose: () => Navigator.of(context).pop()),

              // ---------------- Scrollable form ----------------
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    4,
                    16,
                    24 + bottomInset,
                  ),
                  children: [
                    // Habit name + emoji
                    _NameCard(
                      controller: _nameController,
                      descriptionController: _descriptionController,
                      selectedEmoji: _selectedEmoji,
                      accent: _selectedColor,
                    ),
                    const SizedBox(height: 20),

                    // Emoji picker
                    _Section(
                      title: 'Pick an icon',
                      child: _EmojiPicker(
                        emojis: _emojis,
                        selected: _selectedEmoji,
                        accent: _selectedColor,
                        onChanged: (e) =>
                            setState(() => _selectedEmoji = e),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Frequency
                    _Section(
                      title: 'Frequency',
                      child: _FrequencyPicker(
                        options: _frequencies,
                        selected: _frequency,
                        accent: _selectedColor,
                        onChanged: (f) =>
                            setState(() => _frequency = f),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Reminder
                    _Section(
                      title: 'Reminder',
                      child: _ReminderRow(
                        time: _formatTime(_reminderTime),
                        enabled: _remindersEnabled,
                        accent: _selectedColor,
                        onTap: _pickTime,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Circle
                    _Section(
                      title: 'Assign to circle',
                      child: _CircleChips(
                        options: _circles,
                        selected: _selectedCircle,
                        accent: _selectedColor,
                        onChanged: (c) =>
                            setState(() => _selectedCircle = c),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Color theme
                    _Section(
                      title: 'Theme color',
                      child: _ColorPicker(
                        colors: _colors,
                        selected: _selectedColor,
                        onChanged: (c) =>
                            setState(() => _selectedColor = c),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options
                    _Section(
                      title: 'Options',
                      child: _OptionsCard(
                        shareToCircle: _shareToCircle,
                        remindersEnabled: _remindersEnabled,
                        accent: _selectedColor,
                        onShareChanged: (v) =>
                            setState(() => _shareToCircle = v),
                        onRemindersChanged: (v) =>
                            setState(() => _remindersEnabled = v),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- Create button ----------------
              _CreateBar(
                enabled: _nameController.text.trim().isNotEmpty,
                accent: _selectedColor,
                onPressed: _handleCreate,
              ),
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
class _Header extends StatelessWidget {
  const _Header({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 26),
            color: AppTheme.textPrimary,
            onPressed: onClose,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'New Habit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 46), // balance the close button
        ],
      ),
    );
  }
}

// =============================================================================
// Section wrapper
// =============================================================================
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.textMuted,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// =============================================================================
// Name + description card
// =============================================================================
class _NameCard extends StatelessWidget {
  const _NameCard({
    required this.controller,
    required this.descriptionController,
    required this.selectedEmoji,
    required this.accent,
  });

  final TextEditingController controller;
  final TextEditingController descriptionController;
  final String selectedEmoji;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.15),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  selectedEmoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Run 5km',
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            maxLines: 2,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
            decoration: const InputDecoration(
              hintText: 'Add a short note (optional)',
              hintStyle: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Emoji picker
// =============================================================================
class _EmojiPicker extends StatelessWidget {
  const _EmojiPicker({
    required this.emojis,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  final List<String> emojis;
  final String selected;
  final Color accent;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: emojis.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final emoji = emojis[i];
          final isSelected = emoji == selected;
          return GestureDetector(
            onTap: () => onChanged(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? accent.withValues(alpha: 0.18)
                    : AppTheme.surfaceLight,
                border: Border.all(
                  color: isSelected
                      ? accent
                      : Colors.white.withValues(alpha: 0.05),
                  width: isSelected ? 1.6 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Frequency picker
// =============================================================================
class _FrequencyPicker extends StatelessWidget {
  const _FrequencyPicker({
    required this.options,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final Color accent;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: options.map((o) {
          final isSelected = o == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(o),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            accent,
                            accent.withValues(alpha: 0.65),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  o,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// =============================================================================
// Reminder row
// =============================================================================
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.time,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });

  final String time;
  final bool enabled;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                color: accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Remind me at',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: enabled ? accent : AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Circle chips
// =============================================================================
class _CircleChips extends StatelessWidget {
  const _CircleChips({
    required this.options,
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final Color accent;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((o) {
        final isSelected = o == selected;
        return GestureDetector(
          onTap: () => onChanged(o),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? accent.withValues(alpha: 0.18)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? accent
                    : Colors.white.withValues(alpha: 0.06),
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(Icons.check_rounded, size: 14, color: accent),
                  const SizedBox(width: 6),
                ],
                Text(
                  o,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// =============================================================================
// Color picker
// =============================================================================
class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.colors,
    required this.selected,
    required this.onChanged,
  });

  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final color = colors[i];
          final isSelected = color.toARGB32() == selected.toARGB32();
          return GestureDetector(
            onTap: () => onChanged(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.08),
                  width: isSelected ? 2.4 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: isSelected ? 18 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Options card
// =============================================================================
class _OptionsCard extends StatelessWidget {
  const _OptionsCard({
    required this.shareToCircle,
    required this.remindersEnabled,
    required this.accent,
    required this.onShareChanged,
    required this.onRemindersChanged,
  });

  final bool shareToCircle;
  final bool remindersEnabled;
  final Color accent;
  final ValueChanged<bool> onShareChanged;
  final ValueChanged<bool> onRemindersChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          _OptionRow(
            icon: Icons.group_outlined,
            title: 'Share with circle',
            subtitle: 'Let members see your progress',
            value: shareToCircle,
            accent: accent,
            onChanged: onShareChanged,
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.white.withValues(alpha: 0.06),
          ),
          _OptionRow(
            icon: Icons.alarm_outlined,
            title: 'Enable reminders',
            subtitle: 'Get notified to stay on track',
            value: remindersEnabled,
            accent: accent,
            onChanged: onRemindersChanged,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color accent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: accent,
            activeTrackColor: accent.withValues(alpha: 0.5),
            inactiveThumbColor: AppTheme.textMuted,
            inactiveTrackColor: AppTheme.surfaceLight,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Bottom create bar
// =============================================================================
class _CreateBar extends StatelessWidget {
  const _CreateBar({
    required this.enabled,
    required this.accent,
    required this.onPressed,
  });

  final bool enabled;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.6),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            disabledBackgroundColor: AppTheme.surfaceLight,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: accent.withValues(alpha: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 22,
                color: enabled ? Colors.white : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                'Create Habit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}