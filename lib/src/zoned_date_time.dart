import 'local_date.dart';
import 'local_time.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';
import 'zone_id.dart';

class ZonedDateTime extends DateTime implements Temporal {
  factory ZonedDateTime(
    LocalDate date,
    LocalTime time,
    ZoneId zone,
  ) {
    return switch (zone) {
      ZoneId.system => ZonedDateTime._system(
          date.year,
          date.month,
          date.dayOfMonth,
          time.hour,
          time.minute,
          time.second,
          time.millisecond,
          time.microsecond,
        ),
      ZoneId.utc => ZonedDateTime._utc(
          date.year,
          date.month,
          date.dayOfMonth,
          time.hour,
          time.minute,
          time.second,
          time.millisecond,
          time.microsecond,
        ),
    };
  }

  ZonedDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch)
      : super.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

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

  LocalDate get date => LocalDate(year, month, day);

  LocalTime get time =>
      LocalTime(hour, minute, second, millisecond, microsecond);

  int get prolepticMonth => date.prolepticMonth;

  int get epochDay => date.epochDay;

  int get microsecondOfDay => time.microsecondOfDay;

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
}
