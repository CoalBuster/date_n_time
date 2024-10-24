import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';

class TimeSpan extends Duration implements TemporalAmount {
  const TimeSpan({
    super.days = 0,
    super.hours = 0,
    super.minutes = 0,
    super.seconds = 0,
    super.milliseconds = 0,
    super.microseconds = 0,
  });

  TimeSpan.of(Duration duration) : this(microseconds: duration.inMicroseconds);

  @override
  Temporal addTo(Temporal temporal) {
    if (inMicroseconds != 0) {
      temporal = temporal.plus(inMicroseconds, ChronoUnit.microseconds);
    }

    return temporal;
  }

  @override
  Temporal subtractFrom(Temporal temporal) {
    if (inMicroseconds != 0) {
      temporal = temporal.minus(inMicroseconds, ChronoUnit.microseconds);
    }

    return temporal;
  }

  /// Returns a copy of this [TimeSpan] with the specified units subtracted.
  TimeSpan minus({
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    final subtraction = TimeSpan(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    );
    return TimeSpan.of(this - subtraction);
  }

  /// Returns a copy of this [TimeSpan] with the specified units added.
  TimeSpan plus({
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    final addition = TimeSpan(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    );
    return TimeSpan.of(this + addition);
  }
}
