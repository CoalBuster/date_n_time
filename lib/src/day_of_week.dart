import '../date_n_time.dart';

/// A day-of-week, such as 'Tuesday'.
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// The day-of-week value.
  /// The values are numbered following the ISO-8601 standard,
  /// from 1 (Monday) to 7 (Sunday).
  int get value => index + 1;

  /// Obtains an instance of DayOfWeek from a value.
  /// The value follows the ISO-8601 standard,
  /// from 1 (Monday) to 7 (Sunday).
  static DayOfWeek of(int dayOfWeek) {
    if (dayOfWeek < 1 || dayOfWeek > 7) {
      throw UnsupportedTemporalTypeError(
          'Invalid value for DayOfWeek: $dayOfWeek');
    }

    return DayOfWeek.values[dayOfWeek - 1];
  }
}
