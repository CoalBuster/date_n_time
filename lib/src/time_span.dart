import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

/// A time-based amount of time, such as '34.5 seconds'.
class TimeSpan extends Duration implements TemporalAmount {
  /// A constant for a period of zero.
  static const TimeSpan zero = TimeSpan();

  /// Constructs a new [TimeSpan] instance from components.
  ///
  /// All arguments are 0 by default.
  ///
  /// ```dart
  /// const duration = TimeSpan(days: 1, hours: 8, minutes: 56, seconds: 59,
  ///   milliseconds: 30, microseconds: 10);
  /// print(duration); // 32:56:59.030010
  /// ```
  const TimeSpan({
    super.days = 0,
    super.hours = 0,
    super.minutes = 0,
    super.seconds = 0,
    super.milliseconds = 0,
    super.microseconds = 0,
  });

  /// Creates a new [TimeSpan] instance consisting of the duration,
  /// between [startInclusive] and [endExclusive].
  factory TimeSpan.between(Temporal startInclusive, Temporal endExclusive) {
    try {
      int microseconds =
          startInclusive.until(endExclusive, ChronoUnit.microseconds);
      return TimeSpan(microseconds: microseconds);
    } on UnsupportedTemporalTypeError {
      // Microseconds not supported. Attempt reading milliseconds instead.
    }

    try {
      int milliseconds =
          startInclusive.until(endExclusive, ChronoUnit.milliseconds);
      return TimeSpan(milliseconds: milliseconds);
    } on UnsupportedTemporalTypeError {
      // Milliseconds not supported. Attempt reading seconds instead.
    }

    {
      int seconds = startInclusive.until(endExclusive, ChronoUnit.seconds);
      return TimeSpan(seconds: seconds);
    }
  }

  /// Constructs a new [TimeSpan] instance from the given [duration].
  ///
  /// ```dart
  /// final duration = Duration(hours: 3);
  /// final timeSpan = TimeSpan.of(duration);
  /// print(duration == timeSpan); // true
  /// ```
  TimeSpan.of(Duration duration) : this(microseconds: duration.inMicroseconds);

  /// Adds this [TimeSpan] and [other] and
  /// returns the sum as a new [TimeSpan] object.
  TimeSpan operator +(Duration other) => TimeSpan.of(super + other);

  /// Subtracts [other] from this [TimeSpan] and
  /// returns the difference as a new [TimeSpan] object.
  TimeSpan operator -(Duration other) => TimeSpan.of(super - other);

  /// Creates a new [TimeSpan] with the opposite direction of this [TimeSpan].
  ///
  /// The returned [TimeSpan] has the same length as this one, but will have the
  /// opposite sign (as reported by [isNegative]) as this one where possible.
  TimeSpan operator -() => TimeSpan.of(-super);

  @override
  Temporal addTo(Temporal temporal) {
    if (inMicroseconds != 0) {
      temporal = temporal.plus(inMicroseconds, ChronoUnit.microseconds);
    }

    return temporal;
  }

  @override
  TimeSpan minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours => TimeSpan.of(this - Duration(hours: amountToSubtract)),
      ChronoUnit.minutes =>
        TimeSpan.of(this - Duration(minutes: amountToSubtract)),
      ChronoUnit.seconds =>
        TimeSpan.of(this - Duration(seconds: amountToSubtract)),
      ChronoUnit.milliseconds =>
        TimeSpan.of(this - Duration(milliseconds: amountToSubtract)),
      ChronoUnit.microseconds =>
        TimeSpan.of(this - Duration(microseconds: amountToSubtract)),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  TimeSpan plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.hours => TimeSpan.of(this + Duration(hours: amountToAdd)),
      ChronoUnit.minutes => TimeSpan.of(this + Duration(minutes: amountToAdd)),
      ChronoUnit.seconds => TimeSpan.of(this + Duration(seconds: amountToAdd)),
      ChronoUnit.milliseconds =>
        TimeSpan.of(this + Duration(milliseconds: amountToAdd)),
      ChronoUnit.microseconds =>
        TimeSpan.of(this + Duration(microseconds: amountToAdd)),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  Temporal subtractFrom(Temporal temporal) {
    if (inMicroseconds != 0) {
      temporal = temporal.minus(inMicroseconds, ChronoUnit.microseconds);
    }

    return temporal;
  }
}
