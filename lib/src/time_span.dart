import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

class TimeSpan extends Duration implements TemporalAmount {
  const TimeSpan({
    super.days = 0,
    super.hours = 0,
    super.minutes = 0,
    super.seconds = 0,
    super.milliseconds = 0,
    super.microseconds = 0,
  });

  factory TimeSpan.between(Temporal startInclusive, Temporal endExclusive) {
    try {
      int microseconds =
          startInclusive.until(endExclusive, ChronoUnit.microseconds);
      return TimeSpan(microseconds: microseconds);
    } on UnsupportedTemporalTypeError {}

    try {
      int milliseconds =
          startInclusive.until(endExclusive, ChronoUnit.milliseconds);
      return TimeSpan(milliseconds: milliseconds);
    } on UnsupportedTemporalTypeError {}

    {
      int seconds = startInclusive.until(endExclusive, ChronoUnit.seconds);
      return TimeSpan(seconds: seconds);
    }
  }

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

  // /// Returns a copy of this [TimeSpan] with the specified units subtracted.
  // TimeSpan minus({
  //   int days = 0,
  //   int hours = 0,
  //   int minutes = 0,
  //   int seconds = 0,
  //   int milliseconds = 0,
  //   int microseconds = 0,
  // }) {
  //   final subtraction = TimeSpan(
  //     days: days,
  //     hours: hours,
  //     minutes: minutes,
  //     seconds: seconds,
  //     milliseconds: milliseconds,
  //     microseconds: microseconds,
  //   );
  //   return TimeSpan.of(this - subtraction);
  // }

  // /// Returns a copy of this [TimeSpan] with the specified units added.
  // TimeSpan plus({
  //   int days = 0,
  //   int hours = 0,
  //   int minutes = 0,
  //   int seconds = 0,
  //   int milliseconds = 0,
  //   int microseconds = 0,
  // }) {
  //   final addition = TimeSpan(
  //     days: days,
  //     hours: hours,
  //     minutes: minutes,
  //     seconds: seconds,
  //     milliseconds: milliseconds,
  //     microseconds: microseconds,
  //   );
  //   return TimeSpan.of(this + addition);
  // }
}
