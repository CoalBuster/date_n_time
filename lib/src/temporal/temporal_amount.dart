import 'chrono_unit.dart';
import 'temporal.dart';

/// An amount of time, such as "6 hours" or "8 days".
///
/// Framework-level interface, use concrete types instead.
abstract interface class TemporalAmount {
  /// Returns a new instance of [Temporal] with this [TemporalAmount]
  /// added to the given [temporal].
  Temporal addTo(Temporal temporal);

  /// Returns a new instance of this [TemporalAmount]
  /// with the given [amount] subtracted.
  ///
  /// Throws [UnsupportedTemporalTypeError] if [unit] is not supported.
  TemporalAmount minus(int amount, ChronoUnit unit);

  /// Returns a new instance of this [TemporalAmount]
  /// with the given [amount] added.
  ///
  /// Throws [UnsupportedTemporalTypeError] if [unit] is not supported.
  TemporalAmount plus(int amount, ChronoUnit unit);

  /// Returns a new instance of [Temporal] with this [TemporalAmount]
  /// subtracted from the given [temporal].
  Temporal subtractFrom(Temporal temporal);
}
