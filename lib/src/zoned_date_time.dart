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

class ZonedDateTime extends DateTime implements Temporal {
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

  factory ZonedDateTime.from(Temporal temporal) {
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
  /// If [isUtc] is false, then the date is in the local time zone.
  ///
  /// The constructed [ZonedDateTime] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  ///
  /// ```dart
  /// final newYearsEve =
  ///     ZonedDateTime.fromMicrosecondsSinceEpoch(1640979000000000, isUtc:true);
  /// print(newYearsEve); // 2021-12-31T19:30:00.000Z
  /// ```
  ZonedDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch,
      {bool isUtc = false})
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch, isUtc: isUtc);

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

  LocalDateTime get dateTime => LocalDateTime(date, time);

  LocalDate get date => LocalDate(year, month, day);

  LocalTime get time =>
      LocalTime(hour, minute, second, millisecond, microsecond);

  ZoneId get zone => isUtc ? ZoneId.utc : ZoneId.system;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => date.dayOfWeek;

  /// Whether the year is a leap year.
  ///
  /// See [LocalDate.isLeapYear].
  bool get isLeapYear => date.isLeapYear;

  int get prolepticMonth => date.prolepticMonth;

  int get epochDay => date.epochDay;

  int get microsecondOfDay => time.microsecondOfDay;

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
      ChronoField.year => ZonedDateTime.of(this.copyWith(year: newValue)),
      ChronoField.month => ZonedDateTime.of(this.copyWith(month: newValue)),
      ChronoField.dayOfMonth => ZonedDateTime.of(this.copyWith(day: newValue)),
      ChronoField.hourOfDay => ZonedDateTime.of(this.copyWith(hour: newValue)),
      ChronoField.minute => ZonedDateTime.of(this.copyWith(minute: newValue)),
      ChronoField.second => ZonedDateTime.of(this.copyWith(second: newValue)),
      ChronoField.millisecond =>
        ZonedDateTime.of(this.copyWith(millisecond: newValue)),
      ChronoField.microsecond =>
        ZonedDateTime.of(this.copyWith(microsecond: newValue)),
      ChronoField.epochDay =>
        ZonedDateTime.fromMicrosecondsSinceEpoch(newValue, isUtc: isUtc),
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
    var utc = toUtc().dateTime.minus(amountToSubtract, unit);
    return ZonedDateTime(utc, ZoneId.utc).withZoneSameInstant(zone);
  }

  @override
  ZonedDateTime plus(int amountToAdd, ChronoUnit unit) {
    var utc = toUtc().dateTime.plus(amountToAdd, unit);
    return ZonedDateTime(utc, ZoneId.utc).withZoneSameInstant(zone);
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    final other = ZonedDateTime.from(endExclusive);
    return this.toUtc().dateTime.until(other.toUtc(), unit);
  }

  @override
  ZonedDateTime toLocal() => ZonedDateTime.of(super.toLocal());

  @override
  ZonedDateTime toUtc() => ZonedDateTime.of(super.toUtc());

  @override
  String toString() => toIso8601String();

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

extension LocalDateTimeWithZone on LocalDateTime {
  ZonedDateTime atZone(ZoneId zone) => ZonedDateTime(this, zone);
}
