import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/models/daily_log.dart';
import 'package:nivora/models/goal.dart';
import 'package:nivora/models/habit.dart';
import 'package:nivora/models/habit_log.dart';
import 'package:nivora/services/insights_service.dart';

void main() {
  const service = InsightsService();

  test('calculates daily, weekly, monthly completion and streaks', () {
    final habits = [
      Habit(
        id: 'habit-1',
        userId: 'user-1',
        name: 'Workout',
        description: 'Daily movement',
        active: true,
        frequency: 'daily',
        scheduledDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: DateTime.utc(2026, 8, 10),
        updatedAt: DateTime.utc(2026, 8, 10),
      ),
      Habit(
        id: 'habit-2',
        userId: 'user-1',
        name: 'Read',
        description: 'Read daily',
        active: true,
        frequency: 'daily',
        scheduledDays: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: DateTime.utc(2026, 8, 10),
        updatedAt: DateTime.utc(2026, 8, 10),
      ),
    ];

    final habitLogs = [
      HabitLog(
        id: 'log-1',
        userId: 'user-1',
        habitId: 'habit-1',
        date: DateTime.utc(2026, 8, 16),
        completed: true,
        completedAt: DateTime.utc(2026, 8, 16, 9),
      ),
      HabitLog(
        id: 'log-2',
        userId: 'user-1',
        habitId: 'habit-2',
        date: DateTime.utc(2026, 8, 16),
        completed: false,
        completedAt: null,
      ),
    ];

    final goals = [
      Goal(
        id: 'goal-1',
        userId: 'user-1',
        title: 'Run',
        description: '5K target',
        target: 10,
        currentValue: 5,
        unit: 'sessions',
        deadline: DateTime.utc(2026, 9, 1),
        active: true,
        createdAt: DateTime.utc(2026, 8, 10),
        updatedAt: DateTime.utc(2026, 8, 10),
      ),
    ];

    final dailyLogs = [
      DailyLog(
        id: 'daily-1',
        userId: 'user-1',
        date: DateTime.utc(2026, 8, 16),
        completedHabits: 1,
        totalHabits: 2,
        completionPercentage: 0.5,
        notes: null,
        createdAt: DateTime.utc(2026, 8, 16),
        updatedAt: DateTime.utc(2026, 8, 16),
      ),
      DailyLog(
        id: 'daily-2',
        userId: 'user-1',
        date: DateTime.utc(2026, 8, 15),
        completedHabits: 2,
        totalHabits: 2,
        completionPercentage: 1.0,
        notes: null,
        createdAt: DateTime.utc(2026, 8, 15),
        updatedAt: DateTime.utc(2026, 8, 15),
      ),
      DailyLog(
        id: 'daily-3',
        userId: 'user-1',
        date: DateTime.utc(2026, 8, 14),
        completedHabits: 1,
        totalHabits: 2,
        completionPercentage: 0.5,
        notes: null,
        createdAt: DateTime.utc(2026, 8, 14),
        updatedAt: DateTime.utc(2026, 8, 14),
      ),
    ];

    final snapshot = service.calculate(
      habits: habits,
      habitLogs: habitLogs,
      goals: goals,
      dailyLogs: dailyLogs,
      referenceDate: DateTime.utc(2026, 8, 16),
    );

    expect(snapshot.todayCompletion, 0.5);
    expect(snapshot.weeklyCompletion, closeTo(0.666666, 0.0001));
    expect(snapshot.monthlyCompletion, closeTo(0.666666, 0.0001));
    expect(snapshot.currentStreak, 3);
    expect(snapshot.bestStreak, 3);
    expect(snapshot.habitCompletionCounts['habit-1'], 1);
    expect(snapshot.goalProgress['goal-1'], 0.5);
    expect(snapshot.dailyCompletionHistory.length, 3);
  });
}
