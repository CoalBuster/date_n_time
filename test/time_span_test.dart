import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  test('between positive less than one millisecond', () {
    final start = LocalTime(10, 30, 15, 123, 456);
    final end = LocalTime(10, 30, 15, 124, 356);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, 0);
    expect(duration.inMilliseconds, 0);
    expect(duration.inMicroseconds, 900);
    expect(start + duration, end);
  });

  test('between positive more than one millisecond', () {
    final start = LocalTime(10, 30, 15, 123, 456);
    final end = LocalTime(10, 30, 16, 023, 456);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, 0);
    expect(duration.inMilliseconds, 900);
    expect(duration.inMicroseconds, 900000);
    expect(start + duration, end);
  });

  test('between positive more than one second', () {
    final start = LocalTime(10, 30, 15, 123, 456);
    final end = LocalTime(10, 31, 14, 123, 456);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, 59);
    expect(duration.inMilliseconds, 59000);
    expect(duration.inMicroseconds, 59000000);
    expect(start + duration, end);
  });

  test('between negative less than one millisecond', () {
    final start = LocalTime(10, 30, 15, 124, 356);
    final end = LocalTime(10, 30, 15, 123, 456);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, 0);
    expect(duration.inMilliseconds, 0);
    expect(duration.inMicroseconds, -900);
    expect(start + duration, end);
  });

  test('between negative more than one millisecond', () {
    final start = LocalTime(10, 30, 16, 023, 456);
    final end = LocalTime(10, 30, 15, 123, 456);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, 0);
    expect(duration.inMilliseconds, -900);
    expect(duration.inMicroseconds, -900000);
    expect(start + duration, end);
  });

  test('between negative more than one second', () {
    final start = LocalTime(10, 31, 14, 123, 456);
    final end = LocalTime(10, 30, 15, 123, 456);
    final duration = TimeSpan.between(start, end);
    expect(duration.inHours, 0);
    expect(duration.inMinutes, 0);
    expect(duration.inSeconds, -59);
    expect(duration.inMilliseconds, -59000);
    expect(duration.inMicroseconds, -59000000);
    expect(start + duration, end);
  });

  test('between LocalDates throws', () {
    final start = LocalDate(2024, 10, 26);
    final end = LocalDate(2024, 10, 28);
    expect(() => TimeSpan.between(start, end), throwsUnsupportedError);
  });
}
