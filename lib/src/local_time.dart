import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

class LocalTime implements Comparable<LocalTime>, Temporal {
  static final LocalTime midnight = LocalTime(0, 0);

  final Duration _internal;

  /// Obtains an instance of LocalTime from components.
  LocalTime(
    int hour,
    int minute, [
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : this._(Duration(
          hours: hour,
          minutes: minute,
          seconds: second,
          milliseconds: millisecond,
          microseconds: microsecond,
        ).inMicroseconds);

  /// Obtains the current date from the system clock in the default time-zone.
  factory LocalTime.now() {
    final dateTime = DateTime.now();
    return LocalTime(
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// Constructs a new [LocalTime] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"13:27"`
  /// * `"13:27:00"`
  /// * `"13:27:00.123456789"`
  /// * `"13:27:00,123456789"`
  /// * `"1327"`
  /// * `"132700"`
  /// * `"132700.123456789"`
  /// * `"132700,123456789"`
  factory LocalTime.parse(String formattedString) {
    final regex = RegExp(r'(\d\d)(?::?(\d\d)(?::?(\d\d)(?:[.,](\d+))?)?)?$');
    final match = regex.firstMatch(formattedString);

    if (match == null) {
      throw FormatException("Invalid date format", formattedString);
    }

    int parseIntOrZero(String? matched) {
      if (matched == null) return 0;
      return int.parse(matched);
    }

    int parseMilliAndMicroseconds(String? matched) {
      if (matched == null) return 0;
      int length = matched.length;
      assert(length >= 1);
      int result = 0;
      for (int i = 0; i < 6; i++) {
        result *= 10;
        if (i < matched.length) {
          result += matched.codeUnitAt(i) ^ 0x30;
        }
      }
      return result;
    }

    int hour = int.parse(match[1]!);
    int minute = parseIntOrZero(match[2]);
    int second = parseIntOrZero(match[3]);
    int milliAndMicroseconds = parseMilliAndMicroseconds(match[4]);

    return LocalTime(hour, minute, second, 0, milliAndMicroseconds);
  }

  LocalTime._(int microseconds)
      : _internal = Duration(
            microseconds: microseconds.remainder(Duration.microsecondsPerDay));

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => _internal.inHours;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => _internal.inMinutes.remainder(Duration.minutesPerHour);

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = LocalTime.parse('20:18:04');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => _internal.inSeconds.remainder(Duration.secondsPerMinute);

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalTime.parse('05:01:01.234567');
  /// print(time.millisecond); // 234
  /// ```
  int get millisecond =>
      _internal.inMilliseconds.remainder(Duration.millisecondsPerSecond);

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final time = LocalTime.parse('05:01:01.234567');
  /// print(time.microsecond); // 567
  /// ```
  int get microsecond =>
      _internal.inMicroseconds.remainder(Duration.microsecondsPerMillisecond);

  int get microsecondOfDay => _internal.inMicroseconds;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LocalTime && other._internal == _internal;
  }

  @override
  int get hashCode => _internal.hashCode;

  /// Whether this [LocalTime] occurs before [other].
  bool operator <(LocalTime other) => _internal < other._internal;

  /// Whether this [LocalTime] occurs after [other].
  bool operator >(LocalTime other) => _internal > other._internal;

  /// Whether this [LocalTime] occurs before or at the same moment as [other].
  bool operator <=(LocalTime other) => _internal <= other._internal;

  /// Whether this [LocalTime] occurs after or at the same moment as [other].
  bool operator >=(LocalTime other) => _internal >= other._internal;

  @override
  LocalTime operator +(TemporalAmount amount) =>
      amount.addTo(this) as LocalTime;

  @override
  LocalTime operator -(TemporalAmount amount) =>
      amount.subtractFrom(this) as LocalTime;

  @override
  LocalTime adjust(ChronoField field, int newValue) {
    return switch (field) {
      ChronoField.hourOfDay => _with(hour: newValue),
      ChronoField.minute => _with(minute: newValue),
      ChronoField.second => _with(second: newValue),
      ChronoField.millisecond => _with(millisecond: newValue),
      ChronoField.microsecond => _with(microsecond: newValue),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.hourOfDay => hour,
      ChronoField.minute => minute,
      ChronoField.second => second,
      ChronoField.millisecond => millisecond,
      ChronoField.microsecond => microsecond,
      ChronoField.microsecondOfDay => microsecondOfDay,
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  LocalTime minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours => _with(hour: hour - amountToSubtract),
      ChronoUnit.minutes => _with(minute: minute - amountToSubtract),
      ChronoUnit.seconds => _with(second: second - amountToSubtract),
      ChronoUnit.milliseconds =>
        _with(millisecond: millisecond - amountToSubtract),
      ChronoUnit.microseconds =>
        _with(microsecond: microsecond - amountToSubtract),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  LocalTime plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours => _with(hour: hour + amountToAdd),
      ChronoUnit.minutes => _with(minute: minute + amountToAdd),
      ChronoUnit.seconds => _with(second: second + amountToAdd),
      ChronoUnit.milliseconds => _with(millisecond: millisecond + amountToAdd),
      ChronoUnit.microseconds => _with(microsecond: microsecond + amountToAdd),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours =>
        _microsecondsUntil(endExclusive) ~/ Duration.microsecondsPerHour,
      ChronoUnit.minutes =>
        _microsecondsUntil(endExclusive) ~/ Duration.microsecondsPerMinute,
      ChronoUnit.seconds =>
        _microsecondsUntil(endExclusive) ~/ Duration.microsecondsPerSecond,
      ChronoUnit.milliseconds =>
        _microsecondsUntil(endExclusive) ~/ Duration.microsecondsPerMillisecond,
      ChronoUnit.microseconds => _microsecondsUntil(endExclusive),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  int compareTo(LocalTime other) => _internal.compareTo(other._internal);

  @override
  String toString() {
    String h = hour.toString().padLeft(2, '0');
    String min = minute.toString().padLeft(2, '0');
    String sec = second.toString().padLeft(2, '0');
    String ms = millisecond.toString().padLeft(3, '0');
    String us = microsecond == 0 ? "" : microsecond.toString().padLeft(3, '0');
    return "$h:$min:$sec.$ms$us";
  }

  int _microsecondsUntil(Temporal endExclusive) {
    return endExclusive.get(ChronoField.microsecondOfDay) - microsecondOfDay;
  }

  LocalTime _with({
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return LocalTime(
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
