import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/models/daily_log.dart';
import 'package:nivora/models/event.dart';
import 'package:nivora/models/goal.dart';
import 'package:nivora/models/habit.dart';
import 'package:nivora/models/habit_log.dart';
import 'package:nivora/models/nivora_user_profile.dart';

void main() {
  test('user profile serializes and deserializes', () {
    final profile = NivoraUserProfile(
      uid: 'user-1',
      displayName: 'Nivora User',
      email: 'user@example.com',
      photoUrl: 'https://example.com/photo.png',
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 17),
    );

    final decoded = NivoraUserProfile.fromMap(profile.toMap());

    expect(decoded.uid, 'user-1');
    expect(decoded.displayName, 'Nivora User');
    expect(decoded.email, 'user@example.com');
  });

  test('habit serializes and deserializes', () {
    final habit = Habit(
      id: 'habit-1',
      userId: 'user-1',
      name: 'Workout',
      description: 'Daily movement',
      active: true,
      frequency: 'daily',
      scheduledDays: const [1, 3, 5],
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    );

    final decoded = Habit.fromMap(habit.toMap(), documentId: 'habit-1');

    expect(decoded.id, 'habit-1');
    expect(decoded.userId, 'user-1');
    expect(decoded.scheduledDays, [1, 3, 5]);
  });

  test('habit log serializes and deserializes', () {
    final log = HabitLog(
      id: 'log-1',
      userId: 'user-1',
      habitId: 'habit-1',
      date: DateTime.utc(2026, 8, 16),
      completed: true,
      completedAt: DateTime.utc(2026, 8, 16, 12),
    );

    final decoded = HabitLog.fromMap(log.toMap(), documentId: 'log-1');

    expect(decoded.id, 'log-1');
    expect(decoded.habitId, 'habit-1');
    expect(decoded.completed, isTrue);
  });

  test('event serializes and deserializes', () {
    final event = NivoraEvent(
      id: 'event-1',
      userId: 'user-1',
      title: 'Gym',
      description: 'Workout block',
      startAt: DateTime.utc(2026, 8, 16, 18),
      endAt: DateTime.utc(2026, 8, 16, 19),
      completed: false,
      createdAt: DateTime.utc(2026, 8, 15),
      updatedAt: DateTime.utc(2026, 8, 15),
    );

    final decoded = NivoraEvent.fromMap(event.toMap(), documentId: 'event-1');

    expect(decoded.id, 'event-1');
    expect(decoded.title, 'Gym');
  });

  test('goal serializes and deserializes', () {
    final goal = Goal(
      id: 'goal-1',
      userId: 'user-1',
      title: 'Run',
      description: '5K target',
      target: 10,
      currentValue: 4,
      unit: 'sessions',
      deadline: DateTime.utc(2026, 9, 1),
      active: true,
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    );

    final decoded = Goal.fromMap(goal.toMap(), documentId: 'goal-1');

    expect(decoded.target, 10);
    expect(decoded.currentValue, 4);
  });

  test('daily log serializes and deserializes', () {
    final log = DailyLog(
      id: 'daily-1',
      userId: 'user-1',
      date: DateTime.utc(2026, 8, 16),
      completedHabits: 3,
      totalHabits: 4,
      completionPercentage: 0.75,
      notes: 'Good day',
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    );

    final decoded = DailyLog.fromMap(log.toMap(), documentId: 'daily-1');

    expect(decoded.id, 'daily-1');
    expect(decoded.completionPercentage, 0.75);
  });
}
