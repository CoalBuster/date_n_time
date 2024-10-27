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

  LocalDateTime(LocalDate date, LocalTime time)
      : this.date = date,
        this.time = time;

  factory LocalDateTime.from(Temporal temporal) {
    if (temporal is LocalDateTime) {
      return temporal.copyWith();
    }

    final date = LocalDate.from(temporal);
    final time = LocalTime.from(temporal);
    return LocalDateTime(date, time);
  }

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

  factory LocalDateTime.parse(String formattedString) {
    var dateTime = DateTime.parse(formattedString);
    return LocalDateTime._ofDateTime(dateTime);
  }

  LocalDateTime._ofDateTime(DateTime dateTime)
      : this(
            LocalDate(
              dateTime.year,
              dateTime.month,
              dateTime.day,
            ),
            LocalTime(
              dateTime.hour,
              dateTime.minute,
              dateTime.second,
              dateTime.millisecond,
              dateTime.microsecond,
            ));

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
        LocalDateTime(date.adjust(field, newValue), time),
      ChronoField.hourOfDay ||
      ChronoField.minute ||
      ChronoField.second ||
      ChronoField.millisecond ||
      ChronoField.microsecond =>
        LocalDateTime(date, time.adjust(field, newValue)),
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
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  LocalDateTime minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years ||
      ChronoUnit.months ||
      ChronoUnit.weeks ||
      ChronoUnit.days =>
        LocalDateTime(date.minus(amountToSubtract, unit), time),
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
        LocalDateTime(date.plus(amountToAdd, unit), time),
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
    final other = LocalDateTime.from(endExclusive);
    return switch (unit) {
      ChronoUnit.years || ChronoUnit.months => date.until(other.date, unit),
      ChronoUnit.weeks ||
      ChronoUnit.days ||
      ChronoUnit.hours ||
      ChronoUnit.minutes ||
      ChronoUnit.seconds ||
      ChronoUnit.milliseconds ||
      ChronoUnit.microseconds =>
        _timeUntil(other, unit),
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

  LocalDateTime copyWith({
    int? year,
    int? month,
    int? dayOfMonth,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return LocalDateTime(
        date.copyWith(
          year: year,
          month: month,
          dayOfMonth: dayOfMonth,
        ),
        time.copyWith(
          hour: hour,
          minute: minute,
          second: second,
          millisecond: millisecond,
          microsecond: microsecond,
        ));
  }

  @override
  String toString() => atSystemZone().toIso8601String();

  int _timeUntil(LocalDateTime other, ChronoUnit unit) {
    var duration = Duration(days: date.until(other.date, ChronoUnit.days));
    var dateSpan = switch (unit) {
      ChronoUnit.days => duration.inDays,
      ChronoUnit.hours => duration.inHours,
      ChronoUnit.minutes => duration.inMinutes,
      ChronoUnit.seconds => duration.inSeconds,
      ChronoUnit.milliseconds => duration.inMilliseconds,
      ChronoUnit.microseconds => duration.inMicroseconds,
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
    var timeSpan = time.until(other.time, unit);
    return dateSpan + timeSpan;
  }
}

extension LocalDateWithTime on LocalDate {
  LocalDateTime atStartOfDay() => atTime(LocalTime.midnight);

  LocalDateTime atTime(LocalTime time) => LocalDateTime(this, time);
}

extension LocalTimeWithDate on LocalTime {
  LocalDateTime atDate(LocalDate date) => LocalDateTime(date, this);
}
