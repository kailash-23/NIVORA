import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/habit.dart';
import '../../repositories/habit_repository.dart';
import '../../services/haptics.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.habitRepository,
    this.onSignOut,
  });

  final HabitRepository habitRepository;
  final VoidCallback? onSignOut;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings Toggles State
  bool _notificationsAllowed = true;
  bool _habitReminders = true;
  bool _soundVibration = true;

  // Fitness App Connectivity
  bool _fitnessAppConnected = true;
  bool _smartwatchSync = true;
  bool _heartRateSync = true;

  // App Icon Customization
  String _selectedAppIcon = 'Default Lavender';
  final List<Map<String, String>> _appIcons = const [
    {
      'name': 'Default Lavender',
      'color': '0xFFCBB5F6',
      'desc': 'Original Aesthetic',
    },
    {'name': 'Dark Charcoal', 'color': '0xFF14121B', 'desc': 'Minimal Dark'},
    {'name': 'Pastel Mint', 'color': '0xFFC7F3E2', 'desc': 'Fresh Focus'},
    {'name': 'Vibrant Coral', 'color': '0xFFFFB4A2', 'desc': 'Energy Boost'},
  ];

  void _showAddCustomTaskDialog(
    BuildContext context, {
    String? defaultCategory,
    String? defaultTitle,
  }) {
    final titleController = TextEditingController(text: defaultTitle ?? '');
    final descController = TextEditingController();
    String category = defaultCategory ?? 'Fitness';
    String frequency = 'Daily';

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              title: Row(
                children: const [
                  Icon(Icons.add_task_rounded, color: AppTheme.primaryPurple),
                  SizedBox(width: 10),
                  Text(
                    'Schedule Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'e.g., 30-Min Gym Workout',
                        filled: true,
                        fillColor: AppTheme.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Description / Goal',
                        hintText: 'e.g., Read Chapter 3 of Science book',
                        filled: true,
                        fillColor: AppTheme.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                            'Fitness',
                            'Reading',
                            'Language',
                            'Studies',
                            'Day-to-Day',
                          ].map((cat) {
                            final isSelected = category == cat;
                            return ChoiceChip(
                              label: Text(cat),
                              selected: isSelected,
                              selectedColor: const Color(0xFFD4C0FA),
                              backgroundColor: AppTheme.surfaceSubtle,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppTheme.darkText
                                    : AppTheme.mutedText,
                              ),
                              onSelected: (val) {
                                if (val) {
                                  setDialogState(() {
                                    category = cat;
                                  });
                                }
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Scheduling Frequency',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: frequency,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.surfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Daily',
                          child: Text('Every Day'),
                        ),
                        DropdownMenuItem(
                          value: 'Weekdays',
                          child: Text('Mon - Fri'),
                        ),
                        DropdownMenuItem(
                          value: 'Weekends',
                          child: Text('Sat - Sun'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            frequency = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF14121B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;
                    Haptics.selection();

                    final newHabit = Habit(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: 'local-user',
                      name: titleController.text.trim(),
                      description: descController.text.trim().isNotEmpty
                          ? descController.text.trim()
                          : '$category routine ($frequency)',
                      active: true,
                      frequency: frequency,
                      scheduledDays: const [1, 2, 3, 4, 5, 6, 7],
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await widget.habitRepository.createHabit(newHabit);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Scheduled "$category: ${newHabit.name}" successfully!',
                          ),
                          backgroundColor: AppTheme.primaryPurple,
                        ),
                      );
                      setState(() {});
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'NIVORA SETTINGS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppTheme.darkText,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          // HABIT & TASK SCHEDULER HUB
          _SectionCard(
            title: 'Habit & Task Scheduling Hub',
            subtitle: 'Schedule day-to-day & special tasks',
            icon: Icons.calendar_month_rounded,
            iconBg: const Color(0xFFD4C0FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Preset Special Tasks',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _PresetChip(
                      label: '🏋️ Fitness Workout',
                      onTap: () => _showAddCustomTaskDialog(
                        context,
                        defaultCategory: 'Fitness',
                        defaultTitle: '30-Min Gym Workout',
                      ),
                    ),
                    _PresetChip(
                      label: '📚 Book Reading',
                      onTap: () => _showAddCustomTaskDialog(
                        context,
                        defaultCategory: 'Reading',
                        defaultTitle: 'Read 20 Pages of Book',
                      ),
                    ),
                    _PresetChip(
                      label: '🗣️ Language Study',
                      onTap: () => _showAddCustomTaskDialog(
                        context,
                        defaultCategory: 'Language',
                        defaultTitle: 'Duolingo & Vocab Practice',
                      ),
                    ),
                    _PresetChip(
                      label: '🎓 Study Focus',
                      onTap: () => _showAddCustomTaskDialog(
                        context,
                        defaultCategory: 'Studies',
                        defaultTitle: '2-Hour Deep Study Block',
                      ),
                    ),
                    _PresetChip(
                      label: '⚡ Hydration & Routine',
                      onTap: () => _showAddCustomTaskDialog(
                        context,
                        defaultCategory: 'Day-to-Day',
                        defaultTitle: 'Drink 2.5L Water',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.darkText,
                      side: const BorderSide(
                        color: AppTheme.darkText,
                        width: 1.8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text(
                      'Create Custom Scheduled Task',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => _showAddCustomTaskDialog(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // NOTIFICATIONS & REMINDERS
          _SectionCard(
            title: 'Notifications & Alerts',
            subtitle: 'Configure reminders & sound alerts',
            icon: Icons.notifications_active_rounded,
            iconBg: const Color(0xFFF9D0DF),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Allow Push Notifications',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Receive task and habit alerts'),
                  value: _notificationsAllowed,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _notificationsAllowed = val);
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Habit Reminder Triggers',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Scheduled time-slot reminders'),
                  value: _habitReminders,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _habitReminders = val);
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Sound & Haptic Feedback',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Vibrate and play audio on completion'),
                  value: _soundVibration,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _soundVibration = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // APP ICON CUSTOMIZATION
          _SectionCard(
            title: 'App Icon Customization',
            subtitle: 'Choose your NIVORA app theme icon',
            icon: Icons.palette_rounded,
            iconBg: const Color(0xFFFFF2C2),
            child: Column(
              children: _appIcons.map((item) {
                final isSelected = _selectedAppIcon == item['name'];
                return GestureDetector(
                  onTap: () {
                    Haptics.selection();
                    setState(() => _selectedAppIcon = item['name']!);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3EDFD)
                          : AppTheme.surfaceSubtle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse(item['color']!)),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'N',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: item['color'] == '0xFF14121B'
                                    ? Colors.white
                                    : AppTheme.darkText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              Text(
                                item['desc']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.mutedText,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // FITNESS APP CONNECTIVITY
          _SectionCard(
            title: 'Fitness App Connectivity',
            subtitle: 'Sync health data from wearables & apps',
            icon: Icons.fitness_center_rounded,
            iconBg: const Color(0xFFC7F3E2),
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Google Fit / Apple Health Sync',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Sync daily steps, calories & distance'),
                  value: _fitnessAppConnected,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _fitnessAppConnected = val);
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Smartwatch Activity Monitoring',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Live step counter & active minutes'),
                  value: _smartwatchSync,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _smartwatchSync = val);
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Heart Rate & Sleep Tracking',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Continuous health metrics import'),
                  value: _heartRateSync,
                  activeTrackColor: AppTheme.primaryPurple,
                  onChanged: (val) {
                    Haptics.selection();
                    setState(() => _heartRateSync = val);
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FAF3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Connected • 8,420 steps synced today',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (widget.onSignOut != null) ...[
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.coralTint,
                  foregroundColor: AppTheme.coralRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  'Sign Out of NIVORA',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onPressed: () {
                  Haptics.selection();
                  widget.onSignOut?.call();
                },
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppTheme.darkText, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      backgroundColor: AppTheme.surfaceSubtle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppTheme.darkText,
      ),
      onPressed: () {
        Haptics.selection();
        onTap();
      },
    );
  }
}
