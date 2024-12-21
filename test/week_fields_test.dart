import 'package:date_n_time/date_n_time.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    initializeDateFormatting();
  });

  test('startOfWeek on LocalDate in US', () {
    final start = LocalDate.parse('2024-10-26');
    final expected = LocalDate.parse('2024-10-20');
    final date = start.atStartOfWeek();
    expect(date, expected);
  });

  test('startOfWeek on LocalDateTime in NL', () {
    final start = LocalDateTime.parse('2024-10-26T10:15');
    final expected = LocalDateTime.parse('2024-10-21T10:15');
    final date = start.atStartOfWeek('nl');
    expect(date, expected);
  });

  test('startOfWeek on ZonedDateTime in AR', () {
    Intl.defaultLocale = 'ar';
    final start = ZonedDateTime.parse('2024-10-26T10:15');
    final expected = ZonedDateTime.parse('2024-10-26T10:15');
    final date = start.atStartOfWeek();
    expect(date, expected);
  });

  test('startOfWeek on LocalTime throws', () {
    final start = LocalTime.parse('10:15');
    expect(() => start.atStartOfWeek(), throwsUnsupportedError);
  });
}
