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
  final LocalDate localDate;
  final LocalTime localTime;

  /// Constructs a new [LocalDateTime] by combining a [date] with a [time].
  LocalDateTime(LocalDate date, LocalTime time)
      : this.localDate = date,
        this.localTime = time;

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
  int get year => localDate.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => localDate.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.day); // 20
  /// ```
  int get dayOfMonth => localDate.dayOfMonth;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => localDate.dayOfWeek;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => localTime.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => localTime.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDateTime.parse('1969-07-20 20:18:04');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => localTime.second;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalDateTime.parse('1969-07-20 05:01:01.234567');
  /// print(time.millisecond); // 234
  /// ```
  int get millisecond => localTime.millisecond;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalDateTime.parse('1969-07-20 05:01:01.234567');
  /// print(time.microsecond); // 567
  /// ```
  int get microsecond => localTime.microsecond;

  /// The proleptic month. Count of months since year 0.
  int get prolepticMonth => localDate.prolepticMonth;

  /// The epoch-day. Count of days since epoch (1970-01-01).
  int get epochDay => localDate.epochDay;

  /// The microsecond of day.
  int get microsecondOfDay => localTime.microsecondOfDay;

  /// Returns true if year is a leap year.
  ///
  /// This implements the Gregorian calendar leap year rules wherein
  /// a year is considered to be a leap year if it is divisible by 4,
  /// excepting years divisible by 100, but including years divisible by 400.
  ///
  /// This function assumes the use of the Gregorian calendar
  /// or the proleptic Gregorian calendar.
  bool get isLeapYear => localDate.isLeapYear;

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
    return other is LocalDateTime &&
        localDate == other.localDate &&
        localTime == other.localTime;
  }

  @override
  int get hashCode => Object.hash(localDate, localTime);

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
        LocalDateTime(localDate.adjust(field, newValue), localTime),
      ChronoField.hourOfDay ||
      ChronoField.minute ||
      ChronoField.second ||
      ChronoField.millisecond ||
      ChronoField.microsecond ||
      ChronoField.microsecondOfDay =>
        LocalDateTime(localDate, localTime.adjust(field, newValue)),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.year => localDate.year,
      ChronoField.month => localDate.month,
      ChronoField.dayOfMonth => localDate.dayOfMonth,
      ChronoField.hourOfDay => localTime.hour,
      ChronoField.minute => localTime.minute,
      ChronoField.second => localTime.second,
      ChronoField.millisecond => localTime.millisecond,
      ChronoField.microsecond => localTime.microsecond,
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
      var newDate = localDate.minus(amountToSubtract, unit);
      return LocalDateTime(newDate, localTime);
    } on UnsupportedTemporalTypeError {
      // Not a date unit. Subtract time instead.
    }

    return _plusTime(0 - amountToSubtract, unit);
  }

  @override
  LocalDateTime plus(int amountToAdd, ChronoUnit unit) {
    try {
      var newDate = localDate.plus(amountToAdd, unit);
      return LocalDateTime(newDate, localTime);
    } on UnsupportedTemporalTypeError {
      // Not a date unit. Add time instead.
    }

    return _plusTime(amountToAdd, unit);
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    final other = LocalDateTime.from(endExclusive);
    return switch (unit) {
      ChronoUnit.years ||
      ChronoUnit.months =>
        localDate.until(other.localDate, unit),
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
    int dateCompare = localDate.compareTo(other.localDate);

    if (dateCompare != 0) {
      return dateCompare;
    }

    return localTime.compareTo(other.localTime);
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
        localDate.copyWith(
          year: year,
          month: month,
          dayOfMonth: dayOfMonth,
        ),
        localTime.copyWith(
          hour: hour,
          minute: minute,
          second: second,
          millisecond: millisecond,
          microsecond: microsecond,
        ));
  }

  @override
  String toString() => '${localDate.toString()}T${localTime.toString()}';

  LocalDateTime _plusTime(int amountToAdd, ChronoUnit unit) {
    var dateSpan = switch (unit) {
      ChronoUnit.hours => amountToAdd ~/ Duration.hoursPerDay,
      ChronoUnit.minutes => amountToAdd ~/ Duration.minutesPerDay,
      ChronoUnit.seconds => amountToAdd ~/ Duration.secondsPerDay,
      ChronoUnit.milliseconds => amountToAdd ~/ Duration.millisecondsPerDay,
      ChronoUnit.microseconds => amountToAdd ~/ Duration.microsecondsPerDay,
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
    final newTime = localTime.plus(amountToAdd, unit);

    if (amountToAdd > 0 && newTime < localTime) {
      dateSpan++;
    } else if (amountToAdd < 0 && newTime > localTime) {
      dateSpan--;
    }

    return LocalDateTime(localDate.plus(dateSpan, ChronoUnit.days), newTime);
  }

  int _timeUntil(LocalDateTime other, ChronoUnit unit) {
    var duration =
        Duration(days: localDate.until(other.localDate, ChronoUnit.days));
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
    var timeSpan = localTime.until(other.localTime, unit);
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
