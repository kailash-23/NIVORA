import '../data/firestore_value_utils.dart';

class HabitLog {
  const HabitLog({
    required this.id,
    required this.userId,
    required this.habitId,
    required this.date,
    required this.completed,
    required this.completedAt,
  });

  final String id;
  final String userId;
  final String habitId;
  final DateTime date;
  final bool completed;
  final DateTime? completedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'habitId': habitId,
      'date': firestoreTimestampFromDateTime(date),
      'completed': completed,
      'completedAt': firestoreTimestampFromDateTime(completedAt),
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return HabitLog(
      id: documentId ?? stringFromFirestoreValue(map['id']) ?? '',
      userId: stringFromFirestoreValue(map['userId']) ?? '',
      habitId: stringFromFirestoreValue(map['habitId']) ?? '',
      date: dateTimeFromFirestoreValue(map['date']) ?? DateTime.utc(1970),
      completed: boolFromFirestoreValue(map['completed']),
      completedAt: dateTimeFromFirestoreValue(map['completedAt']),
    );
  }
}
