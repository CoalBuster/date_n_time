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

  ZonedDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch)
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  /// Obtains the current datetime from the system clock in the given time-zone.
  factory ZonedDateTime.now(ZoneId zone) {
    final dateTime = switch (zone) {
      ZoneId.system => DateTime.now(),
      ZoneId.utc => DateTime.timestamp(),
    };
    return ZonedDateTime.of(dateTime);
  }

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
        ZonedDateTime.fromMicrosecondsSinceEpoch(newValue),
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
