import '../day_of_week.dart';
import '../local_date.dart';
import '../local_date_time.dart';
import '../local_time.dart';
import '../zoned_date_time.dart';

/// Extensions on [DateTime] for converting to a temporal.
extension DateTimeExtensions on DateTime {
  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek {
    return switch (this.weekday) {
      DateTime.monday => DayOfWeek.monday,
      DateTime.tuesday => DayOfWeek.tuesday,
      DateTime.wednesday => DayOfWeek.wednesday,
      DateTime.thursday => DayOfWeek.thursday,
      DateTime.friday => DayOfWeek.friday,
      DateTime.saturday => DayOfWeek.saturday,
      DateTime.sunday => DayOfWeek.sunday,
      _ => throw UnimplementedError(),
    };
  }

  /// Retunrs a new [LocalDate] instance from this [DateTime].
  ///
  /// Only the date part is kept. Time and zone information is discarded.
  LocalDate toLocalDate() => LocalDate(
        year,
        month,
        day,
      );

  /// Returns a new [LocalDateTime] instance from this [DateTime].
  ///
  /// Only the date and time parts are kept. Zone information is discarded.
  LocalDateTime toLocalDateTime() => LocalDateTime(
        toLocalDate(),
        toLocalTime(),
      );

  /// Returns a new [LocalTime] instance from this [DateTime].
  ///
  /// Only the time part is kept. Date and zone information is discarded.
  LocalTime toLocalTime() => LocalTime(
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );

  /// Retunrs a new [ZonedDateTime] instance from this [DateTime].
  ZonedDateTime toZonedDateTime() => ZonedDateTime.of(this);
}
