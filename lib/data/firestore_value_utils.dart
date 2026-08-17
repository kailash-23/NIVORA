import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? dateTimeFromFirestoreValue(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is Timestamp) {
    return value.toDate().toUtc();
  }

  if (value is DateTime) {
    return value.toUtc();
  }

  if (value is String) {
    return DateTime.tryParse(value)?.toUtc();
  }

  return null;
}

Timestamp? firestoreTimestampFromDateTime(DateTime? value) {
  if (value == null) {
    return null;
  }

  return Timestamp.fromDate(value.toUtc());
}

String? stringFromFirestoreValue(Object? value) {
  if (value == null) {
    return null;
  }

  return value.toString();
}

bool boolFromFirestoreValue(Object? value, {bool defaultValue = false}) {
  if (value is bool) {
    return value;
  }

  return defaultValue;
}

double doubleFromFirestoreValue(Object? value, {double defaultValue = 0}) {
  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

List<int> intListFromFirestoreValue(Object? value) {
  if (value is! Iterable<Object?>) {
    return const [];
  }

  return value
      .map((item) => item is num ? item.toInt() : int.tryParse('$item'))
      .whereType<int>()
      .toList(growable: false);
}
