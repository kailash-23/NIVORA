import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/habit_log.dart';
import '../../repositories/daily_log_repository.dart';
import '../../repositories/goal_repository.dart';
import '../../repositories/habit_repository.dart';
import '../../services/haptics.dart';
import '../../services/insights_service.dart';
import '../../widgets/analytics_breakdown_grid.dart';
import '../../widgets/average_mood_chart_card.dart';
import '../../widgets/custom_calendar_widget.dart';
import '../../widgets/factors_donut_chart_card.dart';
import '../../widgets/health_trends_hero_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({
    super.key,
    required this.habitRepository,
    required this.goalRepository,
    required this.dailyLogRepository,
    required this.insightsService,
  });

  final HabitRepository habitRepository;
  final GoalRepository goalRepository;
  final DailyLogRepository dailyLogRepository;
  final InsightsService insightsService;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isCalendarExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<_InsightsData>(
          future: _loadInsights(),
          builder: (context, snapshot) {
            final data =
                snapshot.data ??
                _InsightsData(
                  snapshot: widget.insightsService.calculate(
                    habits: const [],
                    habitLogs: const [],
                    goals: const [],
                    dailyLogs: const [],
                  ),
                );

            final snap = data.snapshot;
            final completedSet = snap.dailyCompletionHistory
                .where((log) => log.completionPercentage > 0)
                .map((log) => log.date)
                .toSet();

            return ListView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 140),
              children: [
                // TOP HEADER MATCHING REFERENCE IMAGE 1 & 2
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Haptics.light(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Health trends',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkText,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // HORIZONTAL FILTER CHIPS STRIP FROM REFERENCE IMAGE 2
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: const [
                      _FilterChip(label: 'Factors', hasDropdown: true),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Mood', hasDropdown: true),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Same day', hasDropdown: false),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // FEATURED TOP HERO CARD MATCHING EXACT REFERENCE IMAGE
                const HealthTrendsHeroCard(),

                const SizedBox(height: 24),

                // 2-UP PASTEL METRIC CARDS MATCHING REFERENCE IMAGE 1
                Row(
                  children: [
                    // MINT GREEN CARD (FOCUS TIME)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE2F6EE,
                          ), // Soft mint green pastel
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.access_time_rounded,
                                    size: 18,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                const Icon(
                                  Icons.star_border_rounded,
                                  size: 20,
                                  color: AppTheme.darkText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Focus Time',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.mutedText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '2h 15m',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.darkText,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // SKY BLUE CARD (MOOD LEVEL)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFDEEFEF,
                          ), // Soft sky blue pastel
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.sentiment_satisfied_alt_rounded,
                                    size: 18,
                                    color: AppTheme.darkText,
                                  ),
                                ),
                                const Icon(
                                  Icons.add_rounded,
                                  size: 20,
                                  color: AppTheme.darkText,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Mood Level',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.mutedText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '7/10',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.darkText,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // FEATURED CAPSULE BAR CHART CARD MATCHING REFERENCE IMAGE 1
                const AverageMoodChartCard(),

                const SizedBox(height: 24),

                // DONUT RING CHART CARD MATCHING REFERENCE IMAGE 2
                const FactorsDonutChartCard(),

                const SizedBox(height: 24),

                // 2X2 ANALYTICS BREAKDOWN GRID MATCHING REFERENCE IMAGE 2
                const AnalyticsBreakdownGrid(),

                const SizedBox(height: 24),

                // MONTHLY CALENDAR SECTION (COLLAPSIBLE TO PREVENT LENGTHY PAGE SCROLL)
                GestureDetector(
                  onTap: () {
                    Haptics.selection();
                    setState(() {
                      _isCalendarExpanded = !_isCalendarExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3EEFB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            size: 18,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Monthly Calendar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Visual habit history and completion dots',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _isCalendarExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppTheme.darkText,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isCalendarExpanded) ...[
                  const SizedBox(height: 12),
                  CustomCalendarWidget(
                    selectedDate: _selectedDate,
                    completedDates: completedSet,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<_InsightsData> _loadInsights() async {
    try {
      final habits = await widget.habitRepository.getHabits();
      final goals = await widget.goalRepository.watchActiveGoals().first;
      final dailyLogs = await widget.dailyLogRepository
          .getHistoricalDailyLogs();
      final habitLogs = await _loadHabitLogs();
      final snapshot = widget.insightsService.calculate(
        habits: habits,
        habitLogs: habitLogs,
        goals: goals,
        dailyLogs: dailyLogs,
      );

      return _InsightsData(snapshot: snapshot);
    } catch (_) {
      final snapshot = widget.insightsService.calculate(
        habits: const [],
        habitLogs: const [],
        goals: const [],
        dailyLogs: const [],
      );
      return _InsightsData(snapshot: snapshot);
    }
  }

  Future<List<HabitLog>> _loadHabitLogs() async {
    return widget.habitRepository.getAllHabitLogs();
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.hasDropdown});

  final String label;
  final bool hasDropdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
          if (hasDropdown) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppTheme.darkText,
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightsData {
  const _InsightsData({required this.snapshot});

  final NivoraInsightsSnapshot snapshot;
}
