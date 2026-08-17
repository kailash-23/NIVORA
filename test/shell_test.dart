import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/models/daily_log.dart';
import 'package:nivora/models/event.dart';
import 'package:nivora/models/goal.dart';
import 'package:nivora/models/habit.dart';
import 'package:nivora/models/habit_log.dart';
import 'package:nivora/models/nivora_user_profile.dart';
import 'package:nivora/main.dart';
import 'package:nivora/repositories/daily_log_repository.dart';
import 'package:nivora/repositories/event_repository.dart';
import 'package:nivora/repositories/goal_repository.dart';
import 'package:nivora/repositories/habit_repository.dart';
import 'package:nivora/repositories/nivora_user_repository.dart';
import 'package:nivora/screens/app/nivora_shell.dart';
import 'package:nivora/services/insights_service.dart';

void main() {
  testWidgets('signed out users are routed to login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      NivoraApp(authStateChanges: Stream<User?>.value(null)),
    );

    await tester.pump();

    expect(find.text('NIVORA'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Continue with Google'),
      findsOneWidget,
    );
  });

  testWidgets('signed in users land on Home by default', (
    WidgetTester tester,
  ) async {
    final userRepository = _FakeUserRepository();
    final habitRepository = _FakeHabitRepository();
    final eventRepository = _FakeEventRepository();
    final goalRepository = _FakeGoalRepository();
    final dailyLogRepository = _FakeDailyLogRepository();

    await tester.pumpWidget(
      NivoraApp(
        authStateChanges: Stream<User?>.value(_FakeUser()),
        userRepository: userRepository,
        habitRepository: habitRepository,
        eventRepository: eventRepository,
        goalRepository: goalRepository,
        dailyLogRepository: dailyLogRepository,
        insightsService: const InsightsService(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Tracking Your\nHabits'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(find.text('Upcoming'), findsWidgets);
  });

  testWidgets('bottom navigation switches between shell sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NivoraShell(
          onSignOut: () async {},
          userRepository: _FakeUserRepository(),
          habitRepository: _FakeHabitRepository(),
          eventRepository: _FakeEventRepository(),
          goalRepository: _FakeGoalRepository(),
          dailyLogRepository: _FakeDailyLogRepository(),
          insightsService: const InsightsService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Health trends'), findsWidgets);
  });

  testWidgets('home sign-out action is wired', (WidgetTester tester) async {
    var signOutCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: NivoraShell(
          userRepository: _FakeUserRepository(),
          habitRepository: _FakeHabitRepository(),
          eventRepository: _FakeEventRepository(),
          goalRepository: _FakeGoalRepository(),
          dailyLogRepository: _FakeDailyLogRepository(),
          insightsService: const InsightsService(),
          onSignOut: () async {
            signOutCalled = true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.logout_rounded));
    await tester.pump();

    expect(signOutCalled, isTrue);
  });
}

class _FakeUser implements User {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserRepository extends NivoraUserRepository {
  _FakeUserRepository() : super(auth: _FakeAuth(), firestore: _FakeFirestore());

  static final NivoraUserProfile _profile = NivoraUserProfile(
    uid: 'user-1',
    displayName: 'Nivora User',
    email: 'user@example.com',
    photoUrl: null,
    createdAt: DateTime.utc(2026, 8, 16),
    updatedAt: DateTime.utc(2026, 8, 16),
  );

  @override
  Future<void> updateCurrentUserProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {}

  @override
  Future<NivoraUserProfile> ensureCurrentUserProfile() async => _profile;

  @override
  Future<NivoraUserProfile?> getCurrentUserProfile() async => _profile;
}

class _FakeHabitRepository extends HabitRepository {
  _FakeHabitRepository()
    : super(auth: _FakeAuth(), firestore: _FakeFirestore());

  static final List<Habit> _habits = [
    Habit(
      id: 'habit-1',
      userId: 'user-1',
      name: 'Workout',
      description: 'Daily movement',
      active: true,
      frequency: 'daily',
      scheduledDays: const [1, 2, 3, 4, 5, 6, 7],
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    ),
  ];

  static final List<HabitLog> _logs = [
    HabitLog(
      id: 'log-1',
      userId: 'user-1',
      habitId: 'habit-1',
      date: DateTime.utc(2026, 8, 16),
      completed: true,
      completedAt: DateTime.utc(2026, 8, 16, 9),
    ),
  ];

  @override
  Future<List<Habit>> getHabits() async => _habits;

  @override
  Stream<List<Habit>> watchHabits() => Stream<List<Habit>>.value(_habits);

  @override
  Future<List<HabitLog>> getAllHabitLogs() async => _logs;

  @override
  Future<List<HabitLog>> getCompletionsForDay(DateTime date) async => _logs;
}

class _FakeEventRepository extends EventRepository {
  _FakeEventRepository()
    : super(auth: _FakeAuth(), firestore: _FakeFirestore());

  static final List<NivoraEvent> _events = [
    NivoraEvent(
      id: 'event-1',
      userId: 'user-1',
      title: 'College',
      description: 'Morning class',
      startAt: DateTime.utc(2026, 8, 16, 11),
      endAt: DateTime.utc(2026, 8, 16, 12),
      completed: false,
      createdAt: DateTime.utc(2026, 8, 15),
      updatedAt: DateTime.utc(2026, 8, 15),
    ),
  ];

  @override
  Stream<List<NivoraEvent>> watchUpcomingEvents({DateTime? from}) =>
      Stream<List<NivoraEvent>>.value(_events);
}

class _FakeGoalRepository extends GoalRepository {
  _FakeGoalRepository() : super(auth: _FakeAuth(), firestore: _FakeFirestore());

  static final List<Goal> _goals = [
    Goal(
      id: 'goal-1',
      userId: 'user-1',
      title: 'Run',
      description: 'Weekly running target',
      target: 10,
      currentValue: 4,
      unit: 'sessions',
      deadline: DateTime.utc(2026, 9, 1),
      active: true,
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    ),
  ];

  @override
  Stream<List<Goal>> watchActiveGoals() => Stream<List<Goal>>.value(_goals);
}

class _FakeDailyLogRepository extends DailyLogRepository {
  _FakeDailyLogRepository()
    : super(auth: _FakeAuth(), firestore: _FakeFirestore());

  static final List<DailyLog> _logs = [
    DailyLog(
      id: 'daily-1',
      userId: 'user-1',
      date: DateTime.utc(2026, 8, 16),
      completedHabits: 1,
      totalHabits: 1,
      completionPercentage: 1,
      notes: null,
      createdAt: DateTime.utc(2026, 8, 16),
      updatedAt: DateTime.utc(2026, 8, 16),
    ),
  ];

  @override
  Future<DailyLog?> getDailyLog(DateTime date) async => _logs.first;

  @override
  Future<List<DailyLog>> getHistoricalDailyLogs({
    DateTime? start,
    DateTime? end,
  }) async => _logs;
}

class _FakeAuth extends Fake implements FirebaseAuth {
  @override
  User? get currentUser => _FakeUser();
}

class _FakeFirestore extends Fake implements FirebaseFirestore {}
