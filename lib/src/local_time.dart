import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

/// A time without a time-zone, such as 8:18pm.
class LocalTime implements Comparable<LocalTime>, Temporal {
  /// The time of midnight at the start of the day, '00:00'.
  static final LocalTime midnight = LocalTime(0, 0);

  final Duration _internal;

  /// Constructs a new [LocalTime] instance from components,
  /// like hour, minute and second.
  LocalTime(
    int hour,
    int minute, [
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : _internal = Duration(
          hours: hour,
          minutes: minute,
          seconds: second,
          milliseconds: millisecond,
          microseconds: microsecond,
        );

  /// Constructs a new [LocalTime] instance
  /// from the given temporal.
  ///
  /// Relies on precense of [ChronoField.microsecondOfDay].
  ///
  /// Throws [UnsupportedTemporalTypeError] if unable to convert.
  factory LocalTime.from(Temporal temporal) {
    if (temporal is LocalTime) {
      return temporal.copyWith();
    }

    final microsecondOfDay = temporal.get(ChronoField.microsecondOfDay);
    return LocalTime.ofMicrosecondOfDay(microsecondOfDay);
  }

  /// Constructs a new [LocalTime] instance with current time
  /// in the local timezone.
  ///
  /// ```dart
  /// final now = LocalTime.now();
  /// ```
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

  /// Constructs a new [LocalTime] instance
  /// with the given [microsecondOfDay].
  factory LocalTime.ofMicrosecondOfDay(int microsecondOfDay) {
    return midnight.copyWith(microsecond: microsecondOfDay);
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
      ChronoField.hourOfDay => copyWith(hour: newValue),
      ChronoField.minute => copyWith(minute: newValue),
      ChronoField.second => copyWith(second: newValue),
      ChronoField.millisecond => copyWith(millisecond: newValue),
      ChronoField.microsecond => copyWith(microsecond: newValue),
      ChronoField.microsecondOfDay => LocalTime.ofMicrosecondOfDay(newValue),
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
      ChronoUnit.hours => copyWith(hour: hour - amountToSubtract),
      ChronoUnit.minutes => copyWith(minute: minute - amountToSubtract),
      ChronoUnit.seconds => copyWith(second: second - amountToSubtract),
      ChronoUnit.milliseconds =>
        copyWith(millisecond: millisecond - amountToSubtract),
      ChronoUnit.microseconds =>
        copyWith(microsecond: microsecond - amountToSubtract),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  LocalTime plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours => copyWith(hour: hour + amountToAdd),
      ChronoUnit.minutes => copyWith(minute: minute + amountToAdd),
      ChronoUnit.seconds => copyWith(second: second + amountToAdd),
      ChronoUnit.milliseconds =>
        copyWith(millisecond: millisecond + amountToAdd),
      ChronoUnit.microseconds =>
        copyWith(microsecond: microsecond + amountToAdd),
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

  /// Returns a new instance of this [LocalTime]
  /// with the given individual properties adjusted.
  ///
  /// The [copyWith] method creates a new [LocalTime] object with values
  /// for the properties [LocalTime.hour], [LocalTime.minute], etc,
  /// provided by similarly named arguments, or using the existing value
  /// of the property if no argument, or `null`, is provided.
  ///
  /// Example:
  /// ```dart
  /// final now = LocalTime.now();
  /// final sameMinuteInDifferentHour =
  ///     now.copyWith(hour: 14);
  /// ```
  ///
  /// Property values are allowed to overflow or underflow the range
  /// of the property (like a [hour] outside the 0 to 23 range),
  /// which can affect the more significant properties
  /// (for example, a minute of 61 will result in the minute of 1
  /// of the next hour.)
  LocalTime copyWith({
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
}
