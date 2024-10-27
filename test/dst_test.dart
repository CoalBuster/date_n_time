import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  group('non-UTC ZonedDateTime Daylight Savings tests', () {
    test('plus Period adds applies dst', () {
      final start = ZonedDateTime.parse('2024-10-26T10:30:15.000');
      final expected = ZonedDateTime.parse('2024-11-01T09:30:15.000');
      final end = start + Period(days: 6);
      expect(end.dayOfWeek, DayOfWeek.friday);
      expect(end, expected);
      expect(start < end, true);
      expect(start <= end, true);
      expect(start >= end, false);
      expect(start > end, false);
      expect(end.hour, 9);
      expect(end.minute, 30);
      expect(end.second, 15);
    });

    test('minus Period substracts applies dst', () {
      final start = ZonedDateTime.parse('2024-11-01T09:30:15.000');
      final expected = ZonedDateTime.parse('2023-09-30T10:30:15.000');
      final end = start - Period(years: 1, months: 1, days: 1);
      expect(end.dayOfWeek, DayOfWeek.saturday);
      expect(end, expected);
      expect(start < end, false);
      expect(start <= end, false);
      expect(start >= end, true);
      expect(start > end, true);
      expect(end.hour, 10);
      expect(end.minute, 30);
      expect(end.second, 15);
    });

    test('plus TimeSpan adds applies dst', () {
      final start = ZonedDateTime.parse('2024-10-26T10:30:15.000');
      final expected = ZonedDateTime.parse('2024-10-28T09:30:15.000');
      final end = start + TimeSpan(days: 2);
      final duration = TimeSpan.between(start, end);
      expect(end.dayOfWeek, DayOfWeek.monday);
      expect(end, expected);
      expect(end.hour, 9);
      expect(end.minute, 30);
      expect(end.second, 15);
      expect(duration.inDays, 2);
    });
  }, skip: 'Timezone specific (West-Europe)');
}
