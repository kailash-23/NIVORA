import '../data/firestore_value_utils.dart';

class Habit {
  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.active,
    required this.frequency,
    required this.scheduledDays,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String description;
  final bool active;
  final String frequency;
  final List<int> scheduledDays;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'active': active,
      'frequency': frequency,
      'scheduledDays': scheduledDays,
      'createdAt': firestoreTimestampFromDateTime(createdAt),
      'updatedAt': firestoreTimestampFromDateTime(updatedAt),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Habit(
      id: documentId ?? stringFromFirestoreValue(map['id']) ?? '',
      userId: stringFromFirestoreValue(map['userId']) ?? '',
      name: stringFromFirestoreValue(map['name']) ?? '',
      description: stringFromFirestoreValue(map['description']) ?? '',
      active: boolFromFirestoreValue(map['active'], defaultValue: true),
      frequency: stringFromFirestoreValue(map['frequency']) ?? 'daily',
      scheduledDays: intListFromFirestoreValue(map['scheduledDays']),
      createdAt: dateTimeFromFirestoreValue(map['createdAt']),
      updatedAt: dateTimeFromFirestoreValue(map['updatedAt']),
    );
  }
}
