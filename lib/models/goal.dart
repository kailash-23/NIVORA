import '../data/firestore_value_utils.dart';

class Goal {
  const Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.target,
    required this.currentValue,
    required this.unit,
    required this.deadline,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final double target;
  final double currentValue;
  final String unit;
  final DateTime? deadline;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'target': target,
      'currentValue': currentValue,
      'unit': unit,
      'deadline': firestoreTimestampFromDateTime(deadline),
      'active': active,
      'createdAt': firestoreTimestampFromDateTime(createdAt),
      'updatedAt': firestoreTimestampFromDateTime(updatedAt),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Goal(
      id: documentId ?? stringFromFirestoreValue(map['id']) ?? '',
      userId: stringFromFirestoreValue(map['userId']) ?? '',
      title: stringFromFirestoreValue(map['title']) ?? '',
      description: stringFromFirestoreValue(map['description']) ?? '',
      target: doubleFromFirestoreValue(map['target']),
      currentValue: doubleFromFirestoreValue(map['currentValue']),
      unit: stringFromFirestoreValue(map['unit']) ?? '',
      deadline: dateTimeFromFirestoreValue(map['deadline']),
      active: boolFromFirestoreValue(map['active'], defaultValue: true),
      createdAt: dateTimeFromFirestoreValue(map['createdAt']),
      updatedAt: dateTimeFromFirestoreValue(map['updatedAt']),
    );
  }
}
