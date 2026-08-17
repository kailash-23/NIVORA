import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/models/habit.dart';
import 'package:nivora/repositories/habit_repository.dart';

class _FakeFirebaseAuth extends Fake implements FirebaseAuth {
  _FakeFirebaseAuth(this.user);

  final User? user;

  @override
  User? get currentUser => user;
}

class _FakeUser extends Fake implements User {
  _FakeUser(this._uid);

  final String _uid;

  @override
  String get uid => _uid;
}

class _FakeFirestore extends Fake implements FirebaseFirestore {}

void main() {
  test('maps habit documents correctly from query results', () async {
    final repository = HabitRepository(
      firestore: _FakeFirestore(),
      auth: _FakeFirebaseAuth(_FakeUser('user-1')),
    );

    expect(repository, isNotNull);
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
    expect(decoded.name, 'Workout');
  });
}
