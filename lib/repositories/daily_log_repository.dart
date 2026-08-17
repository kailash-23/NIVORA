import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/firestore_value_utils.dart';
import '../models/daily_log.dart';
import '../services/nivora_date_service.dart';

class DailyLogRepository {
  DailyLogRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    NivoraDateService? dateService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _dateService = dateService ?? const NivoraDateService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NivoraDateService _dateService;

  CollectionReference<Map<String, dynamic>> _dailyLogs(String userId) =>
      _firestore.collection('users').doc(userId).collection('daily_logs');

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user available.');
    }

    return user.uid;
  }

  Future<DailyLog> upsertDailyLog(DailyLog log) async {
    final userId = _requireUserId();
    final normalizedDate = _dateService.normalizeDate(log.date);
    final documentId = _dateService.normalizedDateKey(normalizedDate);
    final created = DailyLog(
      id: documentId,
      userId: userId,
      date: normalizedDate,
      completedHabits: log.completedHabits,
      totalHabits: log.totalHabits,
      completionPercentage: log.completionPercentage,
      notes: log.notes,
      createdAt: log.createdAt ?? DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    await _dailyLogs(
      userId,
    ).doc(documentId).set(created.toMap(), SetOptions(merge: true));
    return created;
  }

  Future<DailyLog?> getDailyLog(DateTime date) async {
    final userId = _requireUserId();
    final normalizedDate = _dateService.normalizeDate(date);
    final documentId = _dateService.normalizedDateKey(normalizedDate);
    final snapshot = await _dailyLogs(userId).doc(documentId).get();
    if (!snapshot.exists) {
      return null;
    }

    return DailyLog.fromMap(
      snapshot.data() ?? <String, dynamic>{},
      documentId: snapshot.id,
    );
  }

  Future<List<DailyLog>> getHistoricalDailyLogs({
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
    final snapshot = await _dailyLogs(userId)
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
        .map((doc) => DailyLog.fromMap(doc.data(), documentId: doc.id))
        .toList(growable: false);
  }
}
