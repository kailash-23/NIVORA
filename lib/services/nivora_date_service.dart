class NivoraDateRange {
  const NivoraDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class NivoraDateService {
  const NivoraDateService();

  DateTime today([DateTime? reference]) =>
      normalizeDate(reference ?? DateTime.now());

  DateTime normalizeDate(DateTime value) =>
      DateTime.utc(value.year, value.month, value.day);

  DateTime startOfWeek(DateTime value) {
    final normalized = normalizeDate(value);
    return normalized.subtract(
      Duration(days: normalized.weekday - DateTime.monday),
    );
  }

  DateTime endOfWeek(DateTime value) =>
      startOfWeek(value).add(const Duration(days: 6));

  DateTime startOfMonth(DateTime value) =>
      DateTime.utc(value.year, value.month, 1);

  DateTime endOfMonth(DateTime value) =>
      DateTime.utc(value.year, value.month + 1, 0);

  NivoraDateRange weekRange(DateTime value) =>
      NivoraDateRange(start: startOfWeek(value), end: endOfWeek(value));

  NivoraDateRange monthRange(DateTime value) =>
      NivoraDateRange(start: startOfMonth(value), end: endOfMonth(value));

  DateTime nextDay(DateTime value) =>
      normalizeDate(value).add(const Duration(days: 1));

  bool isSameDay(DateTime first, DateTime second) =>
      normalizeDate(first) == normalizeDate(second);

  String normalizedDateKey(DateTime value) {
    final normalized = normalizeDate(value);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}$month$day';
  }

  Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var day = normalizeDate(start);
    final last = normalizeDate(end);

    while (!day.isAfter(last)) {
      yield day;
      day = day.add(const Duration(days: 1));
    }
  }
}
