import '../data/firestore_value_utils.dart';

class DailyLog {
  const DailyLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.completedHabits,
    required this.totalHabits,
    required this.completionPercentage,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final DateTime date;
  final int completedHabits;
  final int totalHabits;
  final double completionPercentage;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'date': firestoreTimestampFromDateTime(date),
      'completedHabits': completedHabits,
      'totalHabits': totalHabits,
      'completionPercentage': completionPercentage,
      'notes': notes,
      'createdAt': firestoreTimestampFromDateTime(createdAt),
      'updatedAt': firestoreTimestampFromDateTime(updatedAt),
    };
  }

  factory DailyLog.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return DailyLog(
      id: documentId ?? stringFromFirestoreValue(map['id']) ?? '',
      userId: stringFromFirestoreValue(map['userId']) ?? '',
      date: dateTimeFromFirestoreValue(map['date']) ?? DateTime.utc(1970),
      completedHabits: (map['completedHabits'] as num?)?.toInt() ?? 0,
      totalHabits: (map['totalHabits'] as num?)?.toInt() ?? 0,
      completionPercentage: doubleFromFirestoreValue(
        map['completionPercentage'],
      ),
      notes: stringFromFirestoreValue(map['notes']),
      createdAt: dateTimeFromFirestoreValue(map['createdAt']),
      updatedAt: dateTimeFromFirestoreValue(map['updatedAt']),
    );
  }
}
