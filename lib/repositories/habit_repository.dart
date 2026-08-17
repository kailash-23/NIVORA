import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/firestore_value_utils.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../services/nivora_date_service.dart';

class HabitRepository {
  HabitRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    NivoraDateService? dateService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _dateService = dateService ?? const NivoraDateService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NivoraDateService _dateService;

  CollectionReference<Map<String, dynamic>> get _habits =>
      _firestore.collection('habits');

  CollectionReference<Map<String, dynamic>> _habitLogs(String userId) =>
      _firestore.collection('users').doc(userId).collection('habit_logs');

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    return user.uid;
  }

  Future<Habit> createHabit(Habit habit) async {
    final userId = _requireUserId();
    final reference = habit.id.isEmpty ? _habits.doc() : _habits.doc(habit.id);
    final now = DateTime.now().toUtc();

    final created = Habit(
      id: reference.id,
      userId: userId,
      name: habit.name,
      description: habit.description,
      active: habit.active,
      frequency: habit.frequency,
      scheduledDays: habit.scheduledDays,
      createdAt: habit.createdAt ?? now,
      updatedAt: now,
    );

    await reference.set(created.toMap());
    return created;
  }

  Future<void> updateHabit(Habit habit) async {
    final userId = _requireUserId();
    await _habits
        .doc(habit.id)
        .set(
          Habit(
            id: habit.id,
            userId: userId,
            name: habit.name,
            description: habit.description,
            active: habit.active,
            frequency: habit.frequency,
            scheduledDays: habit.scheduledDays,
            createdAt: habit.createdAt,
            updatedAt: DateTime.now().toUtc(),
          ).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteHabit(String habitId) async {
    _requireUserId();
    await _habits.doc(habitId).delete();
  }

  Future<List<Habit>> getHabits() async {
    final userId = _requireUserId();
    final snapshot = await _habits.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => Habit.fromMap(doc.data(), documentId: doc.id))
        .toList(growable: false);
  }

  Stream<List<Habit>> watchHabits() {
    final userId = _requireUserId();
    return _habits
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Habit.fromMap(doc.data(), documentId: doc.id))
              .toList(growable: false),
        );
  }

  Future<HabitLog> markHabitComplete({
    required String habitId,
    DateTime? date,
  }) async {
    final userId = _requireUserId();
    final normalizedDate = _dateService.normalizeDate(
      date ?? DateTime.now().toUtc(),
    );
    final documentId =
        '${_dateService.normalizedDateKey(normalizedDate)}_$habitId';
    final log = HabitLog(
      id: documentId,
      userId: userId,
      habitId: habitId,
      date: normalizedDate,
      completed: true,
      completedAt: DateTime.now().toUtc(),
    );

    await _habitLogs(
      userId,
    ).doc(documentId).set(log.toMap(), SetOptions(merge: true));
    return log;
  }

  Future<void> undoHabitCompletion({
    required String habitId,
    DateTime? date,
  }) async {
    final userId = _requireUserId();
    final normalizedDate = _dateService.normalizeDate(
      date ?? DateTime.now().toUtc(),
    );
    final documentId =
        '${_dateService.normalizedDateKey(normalizedDate)}_$habitId';
    await _habitLogs(userId).doc(documentId).delete();
  }

  Future<List<HabitLog>> getCompletionsForDay(DateTime date) async {
    final userId = _requireUserId();
    final normalizedDate = _dateService.normalizeDate(date);
    final snapshot = await _habitLogs(userId)
        .where(
          'date',
          isEqualTo: firestoreTimestampFromDateTime(normalizedDate),
        )
        .get();
    return snapshot.docs
        .map((doc) => HabitLog.fromMap(doc.data(), documentId: doc.id))
        .toList(growable: false);
  }

  Future<List<HabitLog>> getHistoricalCompletionData({
    DateTime? start,
    DateTime? end,
  }) async {
    final userId = _requireUserId();
    final normalizedStart = _dateService.normalizeDate(
      start ?? DateTime.now().toUtc().subtract(const Duration(days: 30)),
    );
    final normalizedEnd = _dateService.normalizeDate(
      end ?? DateTime.now().toUtc(),
    );
    final snapshot = await _habitLogs(userId)
        .where(
          'date',
          isGreaterThanOrEqualTo: firestoreTimestampFromDateTime(
            normalizedStart,
          ),
        )
        .where(
          'date',
          isLessThanOrEqualTo: firestoreTimestampFromDateTime(normalizedEnd),
        )
        .orderBy('date')
        .get();
    return snapshot.docs
        .map((doc) => HabitLog.fromMap(doc.data(), documentId: doc.id))
        .toList(growable: false);
  }

  Future<List<HabitLog>> getAllHabitLogs() async {
    final userId = _requireUserId();
    final snapshot = await _habitLogs(userId).orderBy('date').get();
    return snapshot.docs
        .map((doc) => HabitLog.fromMap(doc.data(), documentId: doc.id))
        .toList(growable: false);
  }
}
