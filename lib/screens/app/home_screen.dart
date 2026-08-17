import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/daily_log.dart';
import '../../models/event.dart';
import '../../models/habit.dart';
import '../../models/habit_log.dart';
import '../../models/nivora_user_profile.dart';
import '../../repositories/daily_log_repository.dart';
import '../../repositories/event_repository.dart';
import '../../repositories/habit_repository.dart';
import '../../repositories/nivora_user_repository.dart';
import '../../services/haptics.dart';
import '../../services/nivora_date_service.dart';
import '../../widgets/health_tracker_card.dart';
import '../../widgets/interactive_habit_tile.dart';
import '../../widgets/scheduled_events_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/visit_type_grid.dart';
import '../../widgets/weekday_strip_widget.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onSignOut,
    required this.habitRepository,
    required this.eventRepository,
    required this.dailyLogRepository,
    required this.userRepository,
  });

  final VoidCallback onSignOut;
  final HabitRepository habitRepository;
  final EventRepository eventRepository;
  final DailyLogRepository dailyLogRepository;
  final NivoraUserRepository userRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NivoraDateService _dateService = const NivoraDateService();
  late final Future<NivoraUserProfile?> _profileFuture = widget.userRepository
      .getCurrentUserProfile();
  late final Stream<List<Habit>> _habitsStream = widget.habitRepository
      .watchHabits();
  late final Stream<List<NivoraEvent>> _eventsStream = widget.eventRepository
      .watchUpcomingEvents();
  late final Future<List<HabitLog>> _todayLogsFuture = widget.habitRepository
      .getCompletionsForDay(_dateService.today());
  late final Future<DailyLog?> _todayDailyLogFuture = widget.dailyLogRepository
      .getDailyLog(_dateService.today());

  final Set<String> _locallyCompletedHabits = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<NivoraUserProfile?>(
          future: _profileFuture,
          builder: (context, profileSnapshot) {
            final profile = profileSnapshot.data;

            return StreamBuilder<List<Habit>>(
              stream: _habitsStream,
              builder: (context, habitsSnapshot) {
                final habits = habitsSnapshot.data ?? const <Habit>[];

                return StreamBuilder<List<NivoraEvent>>(
                  stream: _eventsStream,
                  builder: (context, eventsSnapshot) {
                    final events = eventsSnapshot.data ?? const <NivoraEvent>[];

                    return FutureBuilder<List<HabitLog>>(
                      future: _todayLogsFuture,
                      builder: (context, logsSnapshot) {
                        final todayLogs =
                            logsSnapshot.data ?? const <HabitLog>[];

                        return FutureBuilder<DailyLog?>(
                          future: _todayDailyLogFuture,
                          builder: (context, dailySnapshot) {
                            final dailyLog = dailySnapshot.data;

                            return _HomeContent(
                              onSignOut: widget.onSignOut,
                              habitRepository: widget.habitRepository,
                              profile: profile,
                              habits: habits,
                              events: events,
                              todayLogs: todayLogs,
                              dailyLog: dailyLog,
                              dateService: _dateService,
                              locallyCompletedHabits: _locallyCompletedHabits,
                              onToggleHabit: (habitId, isCompleted) {
                                setState(() {
                                  if (isCompleted) {
                                    _locallyCompletedHabits.remove(habitId);
                                  } else {
                                    _locallyCompletedHabits.add(habitId);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({
    required this.onSignOut,
    required this.habitRepository,
    required this.profile,
    required this.habits,
    required this.events,
    required this.todayLogs,
    required this.dailyLog,
    required this.dateService,
    required this.locallyCompletedHabits,
    required this.onToggleHabit,
  });

  final VoidCallback onSignOut;
  final HabitRepository habitRepository;
  final NivoraUserProfile? profile;
  final List<Habit> habits;
  final List<NivoraEvent> events;
  final List<HabitLog> todayLogs;
  final DailyLog? dailyLog;
  final NivoraDateService dateService;
  final Set<String> locallyCompletedHabits;
  final void Function(String habitId, bool currentStatus) onToggleHabit;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _showMenuBottomSheet(BuildContext context) {
    Haptics.selection();
    final displayName =
        widget.profile?.displayName ?? widget.profile?.email ?? 'Jacob';
    final email = widget.profile?.email ?? 'jacob@example.com';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryPurple, Color(0xFFB59BF2)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          displayName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkText,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSubtle,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  title: const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkText,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          habitRepository: widget.habitRepository,
                          onSignOut: widget.onSignOut,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.coralTint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppTheme.coralRed,
                    ),
                  ),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.coralRed,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSignOut();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getGreetingSubtitle() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon!';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawName =
        widget.profile?.displayName?.trim() ??
        widget.profile?.email?.split('@').first ??
        'Jacob';
    final firstName = rawName.split(' ').first;
    final photoUrl = widget.profile?.photoUrl;
    final greetingSubtitle = _getGreetingSubtitle();

    final now = DateTime.now();
    final isTodaySelected =
        _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 140),
      children: [
        // TOP HEADER MATCHING REFERENCE IMAGE
        Row(
          children: [
            // User Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryPurple, Color(0xFFB59BF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: photoUrl != null && photoUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            firstName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        firstName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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
                    'Hello, $firstName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    greetingSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            // Top Right Circle Action Buttons from Reference Image
            GestureDetector(
              onTap: () {
                Haptics.selection();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      habitRepository: widget.habitRepository,
                      onSignOut: widget.onSignOut,
                    ),
                  ),
                );
              },
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: AppTheme.darkText,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _showMenuBottomSheet(context),
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  size: 20,
                  color: AppTheme.darkText,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32), // Generous breathable spacing
        // LARGE BOLD TITLE MATCHING REFERENCE IMAGE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Tracking Your\nHabits',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkText,
                height: 1.02,
                letterSpacing: -1.6,
              ),
            ),
            Text(
              isTodaySelected
                  ? 'Today'
                  : '${_selectedDate.day}/${_selectedDate.month}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.mutedText,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28), // Generous breathable spacing
        // DYNAMIC HORIZONTAL WEEKDAY STRIP (NON-SCROLLING 7-DAY ROW WITH TODAY BADGE)
        WeekdayStripWidget(
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),

        const SizedBox(height: 28), // Generous breathable spacing
        // FEATURED HEALTH TRACKER CARD MATCHING REFERENCE IMAGE
        const HealthTrackerCard(),

        const SizedBox(height: 32), // Generous breathable spacing
        // CATEGORIES / VISIT TYPE GRID MATCHING REFERENCE IMAGE
        const VisitTypeGrid(),

        const SizedBox(height: 32), // Generous breathable spacing
        // SCHEDULED EVENTS CARD (SHOWS SINGLE & REPEATED EVENTS ABOVE TASKS LIST)
        ScheduledEventsCard(events: widget.events, selectedDate: _selectedDate),

        const SizedBox(height: 32), // Generous breathable spacing
        // TODAY'S HABITS & TASKS SECTION
        SectionHeader(
          title: isTodaySelected
              ? 'Today\'s Tasks & Habits'
              : 'Tasks for ${_selectedDate.day}/${_selectedDate.month}',
          subtitle: isTodaySelected
              ? 'Daily habit completion loop'
              : 'Scheduled tasks for selected date',
        ),
        const SizedBox(height: 10),
        if (widget.habits.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppTheme.primaryPurple,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'All scheduled habits are up to date.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          for (final habit in widget.habits) ...[
            Builder(
              builder: (context) {
                final initialCompleted = widget.todayLogs.any(
                  (log) => log.habitId == habit.id && log.completed,
                );
                final isCompleted =
                    widget.locallyCompletedHabits.contains(habit.id)
                    ? !initialCompleted
                    : initialCompleted;
                return InteractiveHabitTile(
                  title: habit.name,
                  subtitle: habit.description.isNotEmpty
                      ? habit.description
                      : 'Daily habit routine',
                  completed: isCompleted,
                  tag: habit.frequency,
                  onToggle: () => widget.onToggleHabit(habit.id, isCompleted),
                );
              },
            ),
          ],

        const SizedBox(height: 20),

        // UPCOMING SCHEDULE
        const SectionHeader(
          title: 'Upcoming',
          subtitle: 'Upcoming blocks and events',
        ),
        const SizedBox(height: 10),
        if (widget.events.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.event_available_rounded,
                  color: AppTheme.primaryPurple,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'No upcoming events scheduled',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkText,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          for (final event in widget.events)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lavenderTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkText,
                          ),
                        ),
                        if (event.description.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
