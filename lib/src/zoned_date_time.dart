import 'day_of_week.dart';
import 'local_date.dart';
import 'local_date_time.dart';
import 'local_time.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';
import 'zone_id.dart';

/// A date-time with a time-zone, such as July 20, 1969, 8:18pm GMT.
class ZonedDateTime extends DateTime implements Temporal {
  /// Constructs a new [LocalDateTime] by combining a [dateTime] with a [zone].
  factory ZonedDateTime(
    LocalDateTime dateTime,
    ZoneId zone,
  ) {
    return switch (zone) {
      ZoneId.system => ZonedDateTime._system(
          dateTime.year,
          dateTime.month,
          dateTime.dayOfMonth,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        ),
      ZoneId.utc => ZonedDateTime._utc(
          dateTime.year,
          dateTime.month,
          dateTime.dayOfMonth,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        ),
    };
  }

  /// Constructs a new [ZonedDateTime] instance
  /// from the given temporal.
  ///
  /// Relies on precense of [ChronoField.epochDay],
  /// [ChronoField.microsecondOfDay] and [ChronoField.offsetSeconds].
  ///
  /// Throws [UnsupportedTemporalTypeError] if unable to convert.
  factory ZonedDateTime.from(Temporal temporal) {
    if (temporal is ZonedDateTime) {
      return temporal.copyWith();
    }

    final zone = _zoneFromOffset(temporal.get(ChronoField.offsetSeconds));
    final dateTime = LocalDateTime.from(temporal);

    if (zone == null) {
      throw UnsupportedTemporalTypeError(
          'Timezone not supported. Did device switch zones?');
    }

    return ZonedDateTime(dateTime, zone);
  }

  /// Constructs a new [ZonedDateTime] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// The constructed [ZonedDateTime] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  ///
  /// ```dart
  /// final newYearsEve =
  ///     ZonedDateTime.fromMicrosecondsSinceEpoch(1640979000000000, ZoneId.utc);
  /// print(newYearsEve); // 2021-12-31T19:30:00.000Z
  /// ```
  ZonedDateTime.fromMicrosecondsSinceEpoch(
      int microsecondsSinceEpoch, ZoneId zone)
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
            isUtc: zone == ZoneId.utc);

  /// Constructs a new [ZonedDateTime] instance with current date and time
  /// in the given [zone].
  ///
  /// ```dart
  /// final nowUtc = ZonedDateTime.now(ZoneId.utc);
  /// ```
  factory ZonedDateTime.now(ZoneId zone) {
    final dateTime = switch (zone) {
      ZoneId.system => DateTime.now(),
      ZoneId.utc => DateTime.timestamp(),
    };
    return ZonedDateTime.of(dateTime);
  }

  /// Constructs a new [ZonedDateTime] instance from the given [dateTime].
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final zonedDateTime = ZonedDateTime.of(now);
  /// print(now == zonedDateTime); // true
  /// ```
  factory ZonedDateTime.of(DateTime dateTime) => dateTime.isUtc
      ? ZonedDateTime._utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        )
      : ZonedDateTime._system(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

  /// Constructs a new [ZonedDateTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// The result is always in either local time or UTC.
  /// If a time zone offset other than UTC is specified,
  /// the time is converted to the equivalent local time.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"2012-02-27 13:27:00"`
  /// * `"2012-02-27 13:27:00.123456789z"`
  /// * `"2012-02-27 13:27:00,123456789z"`
  /// * `"20120227 13:27:00"`
  /// * `"20120227T132700"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"2012-02-27T14Z"`
  /// * `"2012-02-27T14+00:00"`
  /// * `"-123450101 00:00:00 Z"`: in the year -12345.
  /// * `"2002-02-27T14:00:00-0500"`: Same as `"2002-02-27T19:00:00Z"`
  factory ZonedDateTime.parse(String formattedString) {
    var dateTime = DateTime.parse(formattedString);
    return ZonedDateTime.of(dateTime);
  }

  ZonedDateTime._system(
    super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]) : super();

  ZonedDateTime._utc(
    super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]) : super.utc();

  /// Returns a new [LocalDateTime] instance from this [ZonedDateTime].
  ///
  /// Only the date and time parts are kept. Zone information is discarded.
  LocalDateTime get localDateTime => LocalDateTime(localDate, localTime);

  /// Returns a new [LocalDate] instance from this [ZonedDateTime].
  ///
  /// Only the date part is kept. Time and zone information is discarded.
  LocalDate get localDate => LocalDate(year, month, day);

  /// Returns a new [LocalDateTime] instance from this [ZonedDateTime].
  ///
  /// Only the date and time parts are kept. Zone information is discarded.
  LocalTime get localTime =>
      LocalTime(hour, minute, second, millisecond, microsecond);

  /// The zone that this [ZonedDateTime] is in `[utc|system]`.
  ZoneId get zone => isUtc ? ZoneId.utc : ZoneId.system;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => localDate.dayOfWeek;

  /// Whether the year is a leap year.
  ///
  /// See [LocalDate.isLeapYear].
  bool get isLeapYear => localDate.isLeapYear;

  /// The proleptic month. Count of months since year 0.
  int get prolepticMonth => localDate.prolepticMonth;

  /// The epoch-day. Count of days since epoch (1970-01-01).
  int get epochDay => localDate.epochDay;

  /// The microsecond of day.
  int get microsecondOfDay => localTime.microsecondOfDay;

  /// The offset in seconds from UTC.
  int get offsetSeconds => timeZoneOffset.inSeconds;

  /// Whether this [ZonedDateTime] occurs before [other].
  bool operator <(ZonedDateTime other) => compareTo(other) < 0;

  /// Whether this [ZonedDateTime] occurs after [other].
  bool operator >(ZonedDateTime other) => compareTo(other) > 0;

  /// Whether this [ZonedDateTime] occurs before or at the same moment as [other].
  bool operator <=(ZonedDateTime other) => compareTo(other) <= 0;

  /// Whether this [ZonedDateTime] occurs after or at the same moment as [other].
  bool operator >=(ZonedDateTime other) => compareTo(other) >= 0;

  @override
  ZonedDateTime operator +(TemporalAmount amount) =>
      amount.addTo(this) as ZonedDateTime;

  @override
  ZonedDateTime operator -(TemporalAmount amount) =>
      amount.subtractFrom(this) as ZonedDateTime;

  @override
  ZonedDateTime adjust(ChronoField field, int newValue) {
    return switch (field) {
      ChronoField.year ||
      ChronoField.month ||
      ChronoField.dayOfMonth ||
      ChronoField.hourOfDay ||
      ChronoField.minute ||
      ChronoField.second ||
      ChronoField.millisecond ||
      ChronoField.microsecond ||
      ChronoField.epochDay ||
      ChronoField.microsecondOfDay =>
        ZonedDateTime(localDateTime.adjust(field, newValue), zone),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.year => year,
      ChronoField.month => month,
      ChronoField.dayOfMonth => day,
      ChronoField.hourOfDay => hour,
      ChronoField.minute => minute,
      ChronoField.second => second,
      ChronoField.millisecond => millisecond,
      ChronoField.microsecond => microsecond,
      ChronoField.dayOfWeek => dayOfWeek.value,
      ChronoField.prolepticMonth => prolepticMonth,
      ChronoField.epochDay => epochDay,
      ChronoField.microsecondOfDay => microsecondOfDay,
      ChronoField.offsetSeconds => offsetSeconds,
    };
  }

  @override
  ZonedDateTime minus(int amountToSubtract, ChronoUnit unit) {
    var utc = toUtc().localDateTime.minus(amountToSubtract, unit);
    return ZonedDateTime(utc, ZoneId.utc).withZoneSameInstant(zone);
  }

  @override
  ZonedDateTime plus(int amountToAdd, ChronoUnit unit) {
    var utc = toUtc().localDateTime.plus(amountToAdd, unit);
    return ZonedDateTime(utc, ZoneId.utc).withZoneSameInstant(zone);
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    final other = ZonedDateTime.from(endExclusive);
    return this.toUtc().localDateTime.until(other.toUtc(), unit);
  }

  @override
  ZonedDateTime toLocal() => ZonedDateTime.of(super.toLocal());

  @override
  ZonedDateTime toUtc() => ZonedDateTime.of(super.toUtc());

  @override
  String toString() => toIso8601String();

  /// Returns a new instance of this [ZonedDateTime]
  /// with the given individual properties adjusted.
  ///
  /// The [copyWith] method creates a new [ZonedDateTime] object with values
  /// for the properties [ZonedDateTime.year], [ZonedDateTime.hour], etc,
  /// provided by similarly named arguments, or using the existing value
  /// of the property if no argument, or `null`, is provided.
  ///
  /// Example:
  /// ```dart
  /// final now = ZonedDateTime.now();
  /// final sameTimeOnMoonLandingDay =
  ///     now.copyWith(year: 1969, month: 07, dayOfMonth: 20);
  /// ```
  ///
  /// Property values are allowed to overflow or underflow the range
  /// of the property (like a [month] outside the 1 to 12 range),
  /// which can affect the more significant properties
  /// (for example, a month of 13 will result in the month of January
  /// of the next year.)
  ///
  /// Notice also that if the result is a local-time ZonedDateTime,
  /// seasonal time-zone adjustments (daylight saving) can cause some
  /// combinations of dates, hours and minutes to not exist, or to exist
  /// more than once.
  /// In the former case, a corresponding time in one of the two adjacent time
  /// zones is used instead. In the latter, one of the two options is chosen.
  ZonedDateTime copyWith({
    int? year,
    int? month,
    int? dayOfMonth,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    ZoneId? zone,
  }) {
    return ZonedDateTime(
      localDateTime.copyWith(
        year: year,
        month: month,
        dayOfMonth: dayOfMonth,
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        microsecond: microsecond,
      ),
      zone ?? this.zone,
    );
  }

  /// Returns a new instance of this [ZonedDateTime] with a different [zone]
  /// at the instant.
  ZonedDateTime withZoneSameInstant(ZoneId zone) {
    return switch (zone) {
      ZoneId.system => toLocal(),
      ZoneId.utc => toUtc(),
    };
  }

  static ZoneId? _zoneFromOffset(int offsetSeconds) {
    var offsets = {
      DateTime.now().timeZoneOffset.inSeconds: ZoneId.system,
      DateTime.timestamp().timeZoneOffset.inSeconds: ZoneId.utc,
    };

    return offsets[offsetSeconds];
  }
}

/// Extensions for constructing a [ZonedDateTime] from a [LocalDateTime].
extension LocalDateTimeWithZone on LocalDateTime {
  /// Combines this [LocalDateTime] with the given [zone]
  /// into a new [ZonedDateTime] instance.
  ZonedDateTime atZone(ZoneId zone) => ZonedDateTime(this, zone);
}
