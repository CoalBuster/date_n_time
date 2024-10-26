import 'day_of_week.dart';
import 'local_date.dart';
import 'local_time.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

class LocalDateTime implements Comparable<LocalDateTime>, Temporal {
  final LocalDate date;
  final LocalTime time;

  LocalDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : this.of(LocalDate(year, month, day),
            LocalTime(hour, minute, second, millisecond, microsecond));

  LocalDateTime._ofDateTime(DateTime dateTime)
      : this(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

  factory LocalDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch) {
    final dateTime =
        DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
    return LocalDateTime._ofDateTime(dateTime);
  }

  /// Obtains the current date from the system clock in the default time-zone.
  factory LocalDateTime.now() {
    final dateTime = DateTime.now();
    return LocalDateTime._ofDateTime(dateTime);
  }

  LocalDateTime.of(LocalDate date, LocalTime time)
      : this.date = date,
        this.time = time;

  factory LocalDateTime.parse(String formattedString) {
    var dateTime = DateTime.parse(formattedString);
    return LocalDateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// The year.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.year); // 1969
  /// ```
  int get year => date.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => date.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int get dayOfMonth => date.dayOfMonth;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => date.dayOfWeek;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => time.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => time.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => time.second;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalTime.parse('05:01:01.234567');
  /// print(time.millisecond); // 234
  /// ```
  int get millisecond => time.millisecond;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalTime.parse('05:01:01.234567');
  /// print(time.microsecond); // 567
  /// ```
  int get microsecond => time.microsecond;

  int get epochDay => date.epochDay;

  int get prolepticMonth => date.prolepticMonth;

  int get microsecondOfDay => time.microsecondOfDay;

  /// Returns true if year is a leap year.
  ///
  /// This implements the Gregorian calendar leap year rules wherein
  /// a year is considered to be a leap year if it is divisible by 4,
  /// excepting years divisible by 100, but including years divisible by 400.
  ///
  /// This function assumes the use of the Gregorian calendar
  /// or the proleptic Gregorian calendar.
  bool get isLeapYear => date.isLeapYear;

  /// Whether this [LocalDateTime] occurs before [other].
  bool operator <(LocalDateTime other) => compareTo(other) < 0;

  /// Whether this [LocalDateTime] occurs after [other].
  bool operator >(LocalDateTime other) => compareTo(other) > 0;

  /// Whether this [LocalDateTime] occurs before or at the same moment as [other].
  bool operator <=(LocalDateTime other) => compareTo(other) <= 0;

  /// Whether this [LocalDateTime] occurs after or at the same moment as [other].
  bool operator >=(LocalDateTime other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LocalDateTime && date == other.date && time == other.time;
  }

  @override
  int get hashCode => Object.hash(date, time);

  @override
  LocalDateTime operator +(TemporalAmount amount) =>
      amount.addTo(this) as LocalDateTime;

  @override
  LocalDateTime operator -(TemporalAmount amount) =>
      amount.subtractFrom(this) as LocalDateTime;

  @override
  LocalDateTime adjust(ChronoField field, int newValue) {
    return switch (field) {
      ChronoField.year ||
      ChronoField.month ||
      ChronoField.dayOfMonth =>
        LocalDateTime.of(date.adjust(field, newValue), time),
      ChronoField.hourOfDay ||
      ChronoField.minute ||
      ChronoField.second ||
      ChronoField.millisecond ||
      ChronoField.microsecond =>
        LocalDateTime.of(date, time.adjust(field, newValue)),
      ChronoField.epochDay =>
        LocalDateTime.fromMicrosecondsSinceEpoch(newValue),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.year => date.year,
      ChronoField.month => date.month,
      ChronoField.dayOfMonth => date.dayOfMonth,
      ChronoField.hourOfDay => time.hour,
      ChronoField.minute => time.minute,
      ChronoField.second => time.second,
      ChronoField.millisecond => time.millisecond,
      ChronoField.microsecond => time.microsecond,
      ChronoField.prolepticMonth => prolepticMonth,
      ChronoField.epochDay => epochDay,
      ChronoField.microsecondOfDay => microsecondOfDay,
    };
  }

  @override
  LocalDateTime minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years ||
      ChronoUnit.months ||
      ChronoUnit.weeks ||
      ChronoUnit.days =>
        LocalDateTime.of(date.minus(amountToSubtract, unit), time),
      ChronoUnit.hours => LocalDateTime._ofDateTime(
          atUtc().subtract(Duration(hours: amountToSubtract))),
      ChronoUnit.minutes => LocalDateTime._ofDateTime(
          atUtc().subtract(Duration(hours: amountToSubtract))),
      ChronoUnit.seconds => LocalDateTime._ofDateTime(
          atUtc().subtract(Duration(hours: amountToSubtract))),
      ChronoUnit.milliseconds => LocalDateTime._ofDateTime(
          atUtc().subtract(Duration(hours: amountToSubtract))),
      ChronoUnit.microseconds => LocalDateTime._ofDateTime(
          atUtc().subtract(Duration(hours: amountToSubtract))),
    };
  }

  @override
  LocalDateTime plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years ||
      ChronoUnit.months ||
      ChronoUnit.weeks ||
      ChronoUnit.days =>
        LocalDateTime.of(date.plus(amountToAdd, unit), time),
      ChronoUnit.hours =>
        LocalDateTime._ofDateTime(atUtc().add(Duration(hours: amountToAdd))),
      ChronoUnit.minutes =>
        LocalDateTime._ofDateTime(atUtc().add(Duration(minutes: amountToAdd))),
      ChronoUnit.seconds =>
        LocalDateTime._ofDateTime(atUtc().add(Duration(seconds: amountToAdd))),
      ChronoUnit.milliseconds => LocalDateTime._ofDateTime(
          atUtc().add(Duration(milliseconds: amountToAdd))),
      ChronoUnit.microseconds => LocalDateTime._ofDateTime(
          atUtc().add(Duration(microseconds: amountToAdd))),
    };
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years ||
      ChronoUnit.months ||
      ChronoUnit.weeks ||
      ChronoUnit.days =>
        date.until(endExclusive, unit),
      ChronoUnit.hours ||
      ChronoUnit.minutes ||
      ChronoUnit.seconds ||
      ChronoUnit.milliseconds ||
      ChronoUnit.microseconds =>
        _timeUntil(endExclusive, unit),
    };
  }

  DateTime atUtc() => DateTime.utc(
        date.year,
        date.month,
        date.dayOfMonth,
        time.hour,
        time.minute,
        time.second,
        time.millisecond,
        time.microsecond,
      );

  DateTime atSystemZone() => DateTime.new(
        date.year,
        date.month,
        date.dayOfMonth,
        time.hour,
        time.minute,
        time.second,
        time.millisecond,
        time.microsecond,
      );

  @override
  int compareTo(LocalDateTime other) {
    int dateCompare = date.compareTo(other.date);

    if (dateCompare != 0) {
      return dateCompare;
    }

    return time.compareTo(other.time);
  }

  @override
  String toString() => atSystemZone().toIso8601String();

  int _timeUntil(Temporal endExclusive, ChronoUnit unit) {
    var days = Duration(days: date.until(endExclusive, ChronoUnit.days));
    var microseconds = Duration(
        microseconds: time.until(endExclusive, ChronoUnit.microseconds));
    var duration = days + microseconds;

    return switch (unit) {
      ChronoUnit.hours => duration.inHours,
      ChronoUnit.minutes => duration.inMinutes,
      ChronoUnit.seconds => duration.inSeconds,
      ChronoUnit.milliseconds => duration.inMilliseconds,
      ChronoUnit.microseconds => duration.inMicroseconds,
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }
}
