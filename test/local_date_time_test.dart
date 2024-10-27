import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  test('parse valid date', () {
    final date = LocalDateTime.parse('2010-02-27T10:30:15');
    expect(date.year, 2010);
    expect(date.month, 2);
    expect(date.dayOfMonth, 27);
    expect(date.dayOfWeek, DayOfWeek.saturday);
    expect(date.hour, 10);
    expect(date.minute, 30);
    expect(date.second, 15);
    expect(date.millisecond, 0);
    expect(date.microsecond, 0);
    expect(date.toString(), '2010-02-27T10:30:15.000');
  });

  test('parse leap year', () {
    final date = LocalDateTime.parse('2012-02-29T10:30:15');
    expect(date.year, 2012);
    expect(date.month, 2);
    expect(date.dayOfMonth, 29);
    expect(date.dayOfWeek, DayOfWeek.wednesday);
    expect(date.hour, 10);
    expect(date.minute, 30);
    expect(date.second, 15);
    expect(date.millisecond, 0);
    expect(date.microsecond, 0);
    expect(date.isLeapYear, true);
    expect(date.toString(), '2012-02-29T10:30:15.000');
  });

  test('parse rolls date', () {
    final date = LocalDateTime.parse('2012-02-30T10:30:15');
    expect(date.year, 2012);
    expect(date.month, 3);
    expect(date.dayOfMonth, 1);
    expect(date.dayOfWeek, DayOfWeek.thursday);
    expect(date.hour, 10);
    expect(date.minute, 30);
    expect(date.second, 15);
    expect(date.millisecond, 0);
    expect(date.microsecond, 0);
    expect(date.toString(), '2012-03-01T10:30:15.000');
  });

  test('plus Period adds ignores dst', () {
    final start = LocalDateTime.parse('2024-10-26T10:30:15.000');
    final expected = LocalDateTime.parse('2024-11-01T10:30:15.000');
    final end = start + Period(days: 6);
    expect(end.dayOfWeek, DayOfWeek.friday);
    expect(end, expected);
    expect(start < end, true);
    expect(start <= end, true);
    expect(start >= end, false);
    expect(start > end, false);
    expect(end.hour, 10);
    expect(end.minute, 30);
    expect(end.second, 15);
  });

  test('minus Period substracts ignores dst', () {
    final start = LocalDateTime.parse('2024-10-01T10:30:15.000');
    final expected = LocalDateTime.parse('2023-08-31T10:30:15.000');
    final end = start - Period(years: 1, months: 1, days: 1);
    expect(end.dayOfWeek, DayOfWeek.thursday);
    expect(end, expected);
    expect(start < end, false);
    expect(start <= end, false);
    expect(start >= end, true);
    expect(start > end, true);
    expect(end.hour, 10);
    expect(end.minute, 30);
    expect(end.second, 15);
  });

  test('plus TimeSpan adds ignores dst', () {
    final start = LocalDateTime.parse('2024-10-26T10:30:15.000');
    final expected = LocalDateTime.parse('2024-10-28T10:30:15.000');
    final end = start + TimeSpan(days: 2);
    final duration = TimeSpan.between(start, end);
    expect(end.dayOfWeek, DayOfWeek.monday);
    expect(end, expected);
    expect(end.hour, 10);
    expect(end.minute, 30);
    expect(end.second, 15);
    expect(duration.inDays, 2);
  });

  test('compare with earlier time', () {
    final start = LocalDateTime.parse('2024-10-28');
    final end = LocalDateTime.parse('2024-10-26');
    expect(start == end, false);
    expect(start < end, false);
    expect(start <= end, false);
    expect(start >= end, true);
    expect(start > end, true);
  });

  test('compare with equal time', () {
    final start = LocalDateTime.parse('2024-10-26');
    final end = LocalDateTime.parse('2024-10-26');
    expect(start == end, true);
    expect(start < end, false);
    expect(start <= end, true);
    expect(start >= end, true);
    expect(start > end, false);
  });

  test('compare with later time', () {
    final start = LocalDateTime.parse('2024-10-26');
    final end = LocalDateTime.parse('2024-10-28');
    expect(start == end, false);
    expect(start < end, true);
    expect(start <= end, true);
    expect(start >= end, false);
    expect(start > end, false);
  });
}
