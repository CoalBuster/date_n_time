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
    final start = LocalDateTime(2024, 10, 26, 10, 30, 15);
    final expected = LocalDateTime(2024, 10, 28, 10, 30, 15);
    final end = start + Period(days: 2);
    final period = Period.between(start, end);
    expect(end.dayOfWeek, DayOfWeek.monday);
    expect(end, expected);
    expect(end.hour, 10);
    expect(end.minute, 30);
    expect(end.second, 15);
    expect(period.months, 0);
    expect(period.days, 2);
  });

  test('plus TimeSpan adds ignores dst', () {
    final start = LocalDateTime(2024, 10, 26, 10, 30, 15);
    final expected = LocalDateTime(2024, 10, 28, 10, 30, 15);
    final end = start + TimeSpan(days: 2);
    final duration = TimeSpan.between(start, end);
    expect(end.dayOfWeek, DayOfWeek.monday);
    expect(end, expected);
    expect(end.hour, 10);
    expect(end.minute, 30);
    expect(end.second, 15);
    expect(duration.inDays, 2);
  });
}
