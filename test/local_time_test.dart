import 'package:date_n_time/date_n_time.dart';
import 'package:test/test.dart';

void main() {
  test('parse valid time', () {
    final time = LocalTime.parse('10:30:15.123456');
    expect(time.hour, 10);
    expect(time.minute, 30);
    expect(time.second, 15);
    expect(time.millisecond, 123);
    expect(time.microsecond, 456);
    expect(time.toString(), '10:30:15.123456');
  });

  test('parse rolls time', () {
    final time = LocalTime.parse('25:65:65');
    expect(time.hour, 2);
    expect(time.minute, 6);
    expect(time.second, 5);
    expect(time.millisecond, 0);
    expect(time.microsecond, 0);
    expect(time.toString(), '02:06:05.000');
  });

  test('plus TimeSpan adds ignores dst', () {
    final start = LocalTime(10, 30);
    final expected = LocalTime(11, 15);
    final end = start + TimeSpan(days: 2, minutes: 45);
    final duration = TimeSpan.between(start, end);
    expect(end, expected);
    expect(duration.inDays, 0);
    expect(duration.inMinutes, 45);
  });

  test('plus TimeSpan throws', () {
    final start = LocalDate(2024, 10, 26);
    expect(() => start + TimeSpan(days: 2), throwsUnsupportedError);
  });
}
