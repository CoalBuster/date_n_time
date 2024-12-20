import 'temporal/unsupported_temporal_type_error.dart';

/// A day-of-week, such as 'Tuesday'.
enum DayOfWeek {
  /// Monday day-of-week.
  monday,

  /// Tuesday day-of-week.
  tuesday,

  /// Wednesday day-of-week.
  wednesday,

  /// Thursday day-of-week.
  thursday,

  /// Friday day-of-week.
  friday,

  /// Saturday day-of-week.
  saturday,

  /// Sunday day-of-week.
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
