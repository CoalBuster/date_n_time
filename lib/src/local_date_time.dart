import 'day_of_week.dart';
import 'local_date.dart';
import 'local_time.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';
import 'zone_id.dart';

/// A date-time without a time-zone, such as July 20, 1969, 8:18pm.
class LocalDateTime implements Comparable<LocalDateTime>, Temporal {
  final LocalDate date;
  final LocalTime time;

  /// Constructs a new [LocalDateTime] by combining a [date] with a [time].
  LocalDateTime(LocalDate date, LocalTime time)
      : this.date = date,
        this.time = time;

  /// Constructs a new [LocalDateTime] instance
  /// from the given temporal.
  ///
  /// Relies on precense of [ChronoField.epochDay]
  /// and [ChronoField.microsecondOfDay].
  ///
  /// Throws [UnsupportedTemporalTypeError] if unable to convert.
  factory LocalDateTime.from(Temporal temporal) {
    if (temporal is LocalDateTime) {
      return temporal.copyWith();
    }

    final date = LocalDate.from(temporal);
    final time = LocalTime.from(temporal);
    return LocalDateTime(date, time);
  }

  /// Constructs a new [LocalDateTime] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// The constructed [LocalDateTime] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  ///
  /// ```dart
  /// final newYearsEve =
  ///     LocalDateTime.fromMicrosecondsSinceEpoch(1640979000000000, ZoneId.utc);
  /// print(newYearsEve); // 2021-12-31T19:30:00.000
  /// ```
  factory LocalDateTime.fromMicrosecondsSinceEpoch(
      int microsecondsSinceEpoch, ZoneId zone) {
    final dateTime = DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
        isUtc: zone == ZoneId.utc);
    return LocalDateTime._ofDateTime(dateTime);
  }

  /// Constructs a new [LocalDateTime] instance with current date and time
  /// in the local time zone.
  ///
  /// ```dart
  /// final now = LocalDateTime.now();
  /// ```
  factory LocalDateTime.now() {
    final dateTime = DateTime.now();
    return LocalDateTime._ofDateTime(dateTime);
  }

  /// Constructs a new [LocalDateTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789"`
  /// * `"2012-02-27 13:27:00,123456789"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14"`
  /// * `"2012-02-27T14"`
  /// * `"-123450101 00:00:00"`: in the year -12345.
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
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.year); // 1969
  /// ```
  int get year => date.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => date.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.day); // 20
  /// ```
  int get dayOfMonth => date.dayOfMonth;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => date.dayOfWeek;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => time.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => time.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => time.second;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalDateTime.parse('1969-07-20 05:01:01.234567');
  /// print(time.millisecond); // 234
  /// ```
  int get millisecond => time.millisecond;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalDateTime.parse('1969-07-20 05:01:01.234567');
  /// print(time.microsecond); // 567
  /// ```
  int get microsecond => time.microsecond;

  /// The proleptic month. Count of months since year 0.
  int get prolepticMonth => date.prolepticMonth;

  /// The epoch-day. Count of days since epoch (1970-01-01).
  int get epochDay => date.epochDay;

  /// The microsecond of day.
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
      ChronoField.dayOfMonth ||
      ChronoField.epochDay =>
        LocalDateTime(date.adjust(field, newValue), time),
      ChronoField.hourOfDay ||
      ChronoField.minute ||
      ChronoField.second ||
      ChronoField.millisecond ||
      ChronoField.microsecond ||
      ChronoField.microsecondOfDay =>
        LocalDateTime(date, time.adjust(field, newValue)),
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
      ChronoField.dayOfWeek => dayOfWeek.value,
      ChronoField.prolepticMonth => prolepticMonth,
      ChronoField.epochDay => epochDay,
      ChronoField.microsecondOfDay => microsecondOfDay,
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  LocalDateTime minus(int amountToSubtract, ChronoUnit unit) {
    try {
      var newDate = date.minus(amountToSubtract, unit);
      return LocalDateTime(newDate, time);
    } on UnsupportedTemporalTypeError {
      // Not a date unit. Subtract time instead.
    }

    return _plusTime(0 - amountToSubtract, unit);
  }

  @override
  LocalDateTime plus(int amountToAdd, ChronoUnit unit) {
    try {
      var newDate = date.plus(amountToAdd, unit);
      return LocalDateTime(newDate, time);
    } on UnsupportedTemporalTypeError {
      // Not a date unit. Add time instead.
    }

    return _plusTime(amountToAdd, unit);
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

  @override
  int compareTo(LocalDateTime other) {
    int dateCompare = date.compareTo(other.date);

    if (dateCompare != 0) {
      return dateCompare;
    }

    return time.compareTo(other.time);
  }

  /// Returns a new instance of this [LocalDateTime]
  /// with the given individual properties adjusted.
  ///
  /// The [copyWith] method creates a new [LocalDateTime] object with values
  /// for the properties [LocalDateTime.year], [LocalDateTime.hour], etc,
  /// provided by similarly named arguments, or using the existing value
  /// of the property if no argument, or `null`, is provided.
  ///
  /// Example:
  /// ```dart
  /// final now = LocalDateTime.now();
  /// final sameTimeOnMoonLandingDay =
  ///     now.copyWith(year: 1969, month: 07, dayOfMonth: 20);
  /// ```
  ///
  /// Property values are allowed to overflow or underflow the range
  /// of the property (like a [month] outside the 1 to 12 range),
  /// which can affect the more significant properties
  /// (for example, a month of 13 will result in the month of January
  /// of the next year.)
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
  String toString() => '${date.toString()}T${time.toString()}';

  LocalDateTime _plusTime(int amountToAdd, ChronoUnit unit) {
    var dateSpan = switch (unit) {
      ChronoUnit.hours => amountToAdd ~/ Duration.hoursPerDay,
      ChronoUnit.minutes => amountToAdd ~/ Duration.minutesPerDay,
      ChronoUnit.seconds => amountToAdd ~/ Duration.secondsPerDay,
      ChronoUnit.milliseconds => amountToAdd ~/ Duration.millisecondsPerDay,
      ChronoUnit.microseconds => amountToAdd ~/ Duration.microsecondsPerDay,
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
    final newTime = time.plus(amountToAdd, unit);

    if (amountToAdd > 0 && newTime < time) {
      dateSpan++;
    } else if (amountToAdd < 0 && newTime > time) {
      dateSpan--;
    }

    return LocalDateTime(date.plus(dateSpan, ChronoUnit.days), newTime);
  }

  int _timeUntil(LocalDateTime other, ChronoUnit unit) {
    var duration = Duration(days: date.until(other.date, ChronoUnit.days));
    var dateSpan = switch (unit) {
      ChronoUnit.weeks => duration.inDays ~/ DateTime.daysPerWeek,
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

/// Extensions for constructing a [LocalDateTime] from a [LocalDate].
extension LocalDateWithTime on LocalDate {
  /// Combines this [LocalDate] with the time of midnight
  /// to create a new [LocalDateTime] at the start of this date.
  LocalDateTime atStartOfDay() => atTime(LocalTime.midnight);

  /// Combines this [LocalDate] with the given [time]
  /// to create a new [LocalDateTime].
  LocalDateTime atTime(LocalTime time) => LocalDateTime(this, time);
}

/// Extensions for constructing a [LocalDateTime] from a [LocalTime].
extension LocalTimeWithDate on LocalTime {
  /// Combines this [LocalTime] with the given [date]
  /// to create a new [LocalDateTime].
  LocalDateTime atDate(LocalDate date) => LocalDateTime(date, this);
}
