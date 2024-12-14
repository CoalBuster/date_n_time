import 'package:date_n_time/date_n_time.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/locale.dart';
import 'package:test/test.dart';

void main() {
  test('start of week in NL', () {
    initializeDateFormatting();
    final Locale locale = Locale.parse('nl_NL');
    final start = LocalDate.parse('2024-10-26');
    final expected = LocalDate.parse('2024-10-21');
    final date = start.atStartOfWeek(locale);
    expect(date, expected);
  });

  test('start of week in US', () {
    initializeDateFormatting();
    final Locale locale = Locale.parse('en_US');
    final start = LocalDate.parse('2024-10-26');
    final expected = LocalDate.parse('2024-10-20');
    final date = start.atStartOfWeek(locale);
    expect(date, expected);
  });
}
