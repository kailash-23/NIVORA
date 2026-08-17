import 'package:flutter_test/flutter_test.dart';

import 'package:nivora/services/nivora_date_service.dart';

void main() {
  const service = NivoraDateService();

  test('normalizes dates to utc midnight', () {
    final value = service.normalizeDate(DateTime(2026, 8, 16, 18, 42));

    expect(value, DateTime.utc(2026, 8, 16));
  });

  test('computes week and month boundaries', () {
    final reference = DateTime.utc(2026, 8, 19);

    expect(service.startOfWeek(reference), DateTime.utc(2026, 8, 17));
    expect(service.endOfWeek(reference), DateTime.utc(2026, 8, 23));
    expect(service.startOfMonth(reference), DateTime.utc(2026, 8, 1));
    expect(service.endOfMonth(reference), DateTime.utc(2026, 8, 31));
  });

  test('creates normalized date keys', () {
    final key = service.normalizedDateKey(DateTime.utc(2026, 8, 6, 12));

    expect(key, '20260806');
  });
}
