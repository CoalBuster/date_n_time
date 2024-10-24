import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

class LocalDateTime implements Comparable<LocalDateTime>, Temporal {
  final DateTime _internal;

  LocalDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : _internal = DateTime.utc(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  factory LocalDateTime.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch) {
    final dateTime = DateTime.now();
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

  /// Obtains the current date from the system clock in the default time-zone.
  factory LocalDateTime.now() {
    final dateTime = DateTime.now();
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

  int get epochDay =>
      _internal.microsecondsSinceEpoch ~/ Duration.microsecondsPerDay;

  /// Whether this [LocalDateTime] occurs before [other].
  bool operator <(LocalDateTime other) => _internal.isBefore(other._internal);

  /// Whether this [LocalDateTime] occurs after [other].
  bool operator >(LocalDateTime other) => _internal.isAfter(other._internal);

  /// Whether this [LocalDateTime] occurs before or at the same moment as [other].
  bool operator <=(LocalDateTime other) =>
      _internal.isBefore(other._internal) ||
      _internal.isAtSameMomentAs(other._internal);

  /// Whether this [LocalDateTime] occurs after or at the same moment as [other].
  bool operator >=(LocalDateTime other) =>
      _internal.isAfter(other._internal) ||
      _internal.isAtSameMomentAs(other._internal);

  @override
  LocalDateTime operator +(TemporalAmount amount) =>
      amount.addTo(this) as LocalDateTime;

  @override
  LocalDateTime operator -(TemporalAmount amount) =>
      amount.subtractFrom(this) as LocalDateTime;

  @override
  LocalDateTime adjust(ChronoField field, int newValue) {
    return switch (field) {
      ChronoField.year => _with(year: newValue),
      ChronoField.month => _with(month: newValue),
      ChronoField.dayOfMonth => _with(day: newValue),
      ChronoField.hourOfDay => _with(hour: newValue),
      ChronoField.minute => _with(minute: newValue),
      ChronoField.second => _with(second: newValue),
      ChronoField.millisecond => _with(millisecond: newValue),
      ChronoField.microsecond => _with(microsecond: newValue),
      ChronoField.epochDay =>
        LocalDateTime.fromMicrosecondsSinceEpoch(newValue),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.year => _internal.year,
      ChronoField.month => _internal.month,
      ChronoField.dayOfMonth => _internal.day,
      ChronoField.epochDay => epochDay,
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  LocalDateTime minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => _with(year: _internal.year - amountToSubtract),
      ChronoUnit.months => _with(month: _internal.month - amountToSubtract),
      ChronoUnit.weeks =>
        _with(day: _internal.day - amountToSubtract * DateTime.daysPerWeek),
      ChronoUnit.days => _with(day: _internal.day - amountToSubtract),
      ChronoUnit.hours => _with(hour: _internal.hour - amountToSubtract),
      ChronoUnit.minutes => _with(minute: _internal.minute - amountToSubtract),
      ChronoUnit.seconds => _with(second: _internal.second - amountToSubtract),
      ChronoUnit.milliseconds =>
        _with(millisecond: _internal.millisecond - amountToSubtract),
      ChronoUnit.microseconds =>
        _with(microsecond: _internal.microsecond - amountToSubtract),
    };
  }

  @override
  LocalDateTime plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => _with(year: _internal.year + amountToAdd),
      ChronoUnit.months => _with(month: _internal.month + amountToAdd),
      ChronoUnit.weeks =>
        _with(day: _internal.day + amountToAdd * DateTime.daysPerWeek),
      ChronoUnit.days => _with(day: _internal.day + amountToAdd),
      ChronoUnit.hours => _with(hour: _internal.hour + amountToAdd),
      ChronoUnit.minutes => _with(minute: _internal.minute + amountToAdd),
      ChronoUnit.seconds => _with(second: _internal.second + amountToAdd),
      ChronoUnit.milliseconds =>
        _with(millisecond: _internal.millisecond + amountToAdd),
      ChronoUnit.microseconds =>
        _with(microsecond: _internal.microsecond + amountToAdd),
    };
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    return switch (unit) {
      // ChronoUnit.years => _monthsUntil(endExclusive) ~/ DateTime.monthsPerYear,
      // ChronoUnit.months => _monthsUntil(endExclusive),
      // ChronoUnit.weeks => _daysUntil(endExclusive) ~/ DateTime.daysPerWeek,
      // ChronoUnit.days => _daysUntil(endExclusive),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  int compareTo(LocalDateTime other) => _internal.compareTo(other._internal);

// LocalTime toLocalTime() =>;

  LocalDateTime _with({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return LocalDateTime(
      year ?? _internal.year,
      month ?? _internal.month,
      day ?? _internal.day,
      hour ?? _internal.hour,
      minute ?? _internal.minute,
      second ?? _internal.second,
      millisecond ?? _internal.millisecond,
      microsecond ?? _internal.microsecond,
    );
  }
}
