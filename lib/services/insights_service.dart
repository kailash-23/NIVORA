import '../models/daily_log.dart';
import '../models/goal.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import 'nivora_date_service.dart';

class NivoraInsightsSnapshot {
  const NivoraInsightsSnapshot({
    required this.todayCompletion,
    required this.weeklyCompletion,
    required this.monthlyCompletion,
    required this.currentStreak,
    required this.bestStreak,
    required this.habitCompletionCounts,
    required this.habitCompletionTrend,
    required this.goalProgress,
    required this.dailyCompletionHistory,
  });

  final double todayCompletion;
  final double weeklyCompletion;
  final double monthlyCompletion;
  final int currentStreak;
  final int bestStreak;
  final Map<String, int> habitCompletionCounts;
  final List<MapEntry<DateTime, double>> habitCompletionTrend;
  final Map<String, double> goalProgress;
  final List<DailyLog> dailyCompletionHistory;
}

class InsightsService {
  const InsightsService({NivoraDateService? dateService})
    : _dateService = dateService ?? const NivoraDateService();

  final NivoraDateService _dateService;

  NivoraInsightsSnapshot calculate({
    required List<Habit> habits,
    required List<HabitLog> habitLogs,
    required List<Goal> goals,
    required List<DailyLog> dailyLogs,
    DateTime? referenceDate,
  }) {
    final today = _dateService.today(referenceDate);
    final weekRange = _dateService.weekRange(today);
    final monthRange = _dateService.monthRange(today);

    final todaysLogs = habitLogs
        .where((log) => _dateService.isSameDay(log.date, today))
        .toList(growable: false);
    final weeklyDailyLogs = dailyLogs
        .where(
          (log) =>
              !log.date.isBefore(weekRange.start) &&
              !log.date.isAfter(weekRange.end),
        )
        .toList(growable: false);
    final monthlyDailyLogs = dailyLogs
        .where(
          (log) =>
              !log.date.isBefore(monthRange.start) &&
              !log.date.isAfter(monthRange.end),
        )
        .toList(growable: false);

    final habitCompletionCounts = <String, int>{};
    for (final habit in habits) {
      habitCompletionCounts[habit.id] = habitLogs
          .where((log) => log.habitId == habit.id && log.completed)
          .length;
    }

    final streaks = _calculateStreaks(dailyLogs, today);
    final habitCompletionTrend =
        dailyLogs
            .map(
              (log) => MapEntry(
                _dateService.normalizeDate(log.date),
                log.completionPercentage,
              ),
            )
            .toList(growable: false)
          ..sort((first, second) => first.key.compareTo(second.key));
    final goalProgress = <String, double>{
      for (final goal in goals)
        goal.id: goal.target == 0
            ? 0
            : (goal.currentValue / goal.target).clamp(0, 1).toDouble(),
    };

    return NivoraInsightsSnapshot(
      todayCompletion: _completionForDay(todaysLogs, habits.length),
      weeklyCompletion: _averageCompletion(weeklyDailyLogs),
      monthlyCompletion: _averageCompletion(monthlyDailyLogs),
      currentStreak: streaks.currentStreak,
      bestStreak: streaks.bestStreak,
      habitCompletionCounts: habitCompletionCounts,
      habitCompletionTrend: habitCompletionTrend,
      goalProgress: goalProgress,
      dailyCompletionHistory: dailyLogs,
    );
  }

  double _completionForDay(List<HabitLog> logs, int totalHabits) {
    if (totalHabits == 0) {
      return 0;
    }

    return logs.where((log) => log.completed).length / totalHabits;
  }

  double _averageCompletion(List<DailyLog> logs) {
    if (logs.isEmpty) {
      return 0;
    }

    final total = logs.fold<double>(
      0,
      (sum, log) => sum + log.completionPercentage,
    );
    return total / logs.length;
  }

  _StreakResult _calculateStreaks(
    List<DailyLog> dailyLogs,
    DateTime referenceDate,
  ) {
    final normalizedDates =
        dailyLogs
            .where((log) => log.completionPercentage > 0)
            .map((log) => _dateService.normalizeDate(log.date))
            .toSet()
          ..removeWhere(
            (date) => date.isAfter(_dateService.normalizeDate(referenceDate)),
          );

    var currentStreak = 0;
    var cursor = _dateService.normalizeDate(referenceDate);
    while (normalizedDates.contains(cursor)) {
      currentStreak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var bestStreak = 0;
    var sequenceStreak = 0;
    DateTime? previousDate;
    for (final date in normalizedDates.toList()..sort()) {
      if (previousDate == null || date.difference(previousDate).inDays == 1) {
        sequenceStreak += 1;
      } else {
        sequenceStreak = 1;
      }

      bestStreak = sequenceStreak > bestStreak ? sequenceStreak : bestStreak;
      previousDate = date;
    }

    return _StreakResult(currentStreak: currentStreak, bestStreak: bestStreak);
  }
}

class _StreakResult {
  const _StreakResult({required this.currentStreak, required this.bestStreak});

  final int currentStreak;
  final int bestStreak;
}
