import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  test('parse valid date', () {
    final date = LocalDate.parse('2010-02-27');
    expect(date.year, 2010);
    expect(date.month, 2);
    expect(date.dayOfMonth, 27);
    expect(date.dayOfWeek, DayOfWeek.saturday);
    expect(date.toString(), '2010-02-27');
  });

  test('parse leap year', () {
    final date = LocalDate.parse('2012-02-29');
    expect(date.year, 2012);
    expect(date.month, 2);
    expect(date.dayOfMonth, 29);
    expect(date.dayOfWeek, DayOfWeek.wednesday);
    expect(date.isLeapYear, true);
    expect(date.toString(), '2012-02-29');
  });

  test('parse rolls date', () {
    final date = LocalDate.parse('2012-02-30');
    expect(date.year, 2012);
    expect(date.month, 3);
    expect(date.dayOfMonth, 1);
    expect(date.dayOfWeek, DayOfWeek.thursday);
    expect(date.toString(), '2012-03-01');
  });

  test('plus Period adds ignores dst', () {
    final start = LocalDate(2024, 10, 26);
    final expected = LocalDate(2024, 10, 28);
    final end = start + Period(days: 2);
    final period = Period.between(start, end);
    expect(end.dayOfWeek, DayOfWeek.monday);
    expect(end, expected);
    expect(period.months, 0);
    expect(period.days, 2);
  });

  test('plus TimeSpan throws', () {
    final start = LocalDate(2024, 10, 26);
    expect(() => start + TimeSpan(days: 2), throwsUnsupportedError);
  });
}
