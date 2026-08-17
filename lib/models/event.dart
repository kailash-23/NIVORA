import '../data/firestore_value_utils.dart';

class NivoraEvent {
  const NivoraEvent({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.completed,
    this.isRepeated = false,
    this.recurrenceRule = 'Single Event',
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime startAt;
  final DateTime endAt;
  final bool completed;
  final bool isRepeated;
  final String recurrenceRule;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'startAt': firestoreTimestampFromDateTime(startAt),
      'endAt': firestoreTimestampFromDateTime(endAt),
      'completed': completed,
      'isRepeated': isRepeated,
      'recurrenceRule': recurrenceRule,
      'createdAt': firestoreTimestampFromDateTime(createdAt),
      'updatedAt': firestoreTimestampFromDateTime(updatedAt),
    };
  }

  factory NivoraEvent.fromMap(Map<String, dynamic> map, {String? documentId}) {
    final rawRecurrence = stringFromFirestoreValue(map['recurrenceRule']);
    final rawRepeated = boolFromFirestoreValue(map['isRepeated']);

    return NivoraEvent(
      id: documentId ?? stringFromFirestoreValue(map['id']) ?? '',
      userId: stringFromFirestoreValue(map['userId']) ?? '',
      title: stringFromFirestoreValue(map['title']) ?? '',
      description: stringFromFirestoreValue(map['description']) ?? '',
      startAt: dateTimeFromFirestoreValue(map['startAt']) ?? DateTime.utc(1970),
      endAt: dateTimeFromFirestoreValue(map['endAt']) ?? DateTime.utc(1970),
      completed: boolFromFirestoreValue(map['completed']),
      isRepeated:
          rawRepeated ||
          (rawRecurrence != null && rawRecurrence != 'Single Event'),
      recurrenceRule:
          rawRecurrence ?? (rawRepeated ? 'Repeated Daily' : 'Single Event'),
      createdAt: dateTimeFromFirestoreValue(map['createdAt']),
      updatedAt: dateTimeFromFirestoreValue(map['updatedAt']),
    );
  }
}
