import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  test('between positive less than one month', () {
    final start = LocalDate(2024, 10, 26);
    final end = LocalDate(2024, 11, 9);
    final period = Period.between(start, end);
    expect(period.months, 0);
    expect(period.days, 14);
    expect(start + period, end);
  });

  test('between positive more than one month', () {
    final start = LocalDate(2024, 10, 26);
    final end = LocalDate(2024, 11, 30);
    final period = Period.between(start, end);
    expect(period.years, 0);
    expect(period.months, 1);
    expect(period.days, 4);
    expect(start + period, end);
  });

  test('between positive more than one year', () {
    final start = LocalDate(2024, 10, 26);
    final end = LocalDate(2025, 11, 30);
    final period = Period.between(start, end);
    expect(period.years, 1);
    expect(period.months, 1);
    expect(period.days, 4);
    expect(start + period, end);
  });

  test('between negative less than one month', () {
    final start = LocalDate(2024, 11, 9);
    final end = LocalDate(2024, 10, 26);
    final period = Period.between(start, end);
    expect(period.months, 0);
    expect(period.days, -14);
    expect(start + period, end);
  });

  test('between negative more than one month', () {
    final start = LocalDate(2024, 11, 30);
    final end = LocalDate(2024, 10, 26);
    final period = Period.between(start, end);
    expect(period.years, 0);
    expect(period.months, -1);
    expect(period.days, -4);
    expect(start + period, end);
  });

  test('between negative more than one year', () {
    final start = LocalDate(2025, 11, 30);
    final end = LocalDate(2024, 10, 26);
    final period = Period.between(start, end);
    expect(period.years, -1);
    expect(period.months, -1);
    expect(period.days, -4);
    expect(start + period, end);
  });

  test('between LocalTimes throws', () {
    final start = LocalTime(10, 30);
    final end = LocalTime(11, 15);
    expect(() => Period.between(start, end), throwsUnsupportedError);
  });
}
