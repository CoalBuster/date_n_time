import 'chrono_field.dart';
import 'chrono_unit.dart';
import 'temporal_amount.dart';

/// A moment in time, such as a date, time, or a combination of both.
///
/// Framework-level interface, use concrete types instead.
abstract interface class Temporal {
  /// Returns a new instance of this [Temporal]
  /// with the given [field] adjusted to [newValue].
  ///
  /// Throws [UnsupportedTemporalTypeError] if [field] is not supported.
  Temporal adjust(ChronoField field, int newValue);

  /// Returns the value for the given [field] of this [Temporal].
  ///
  /// Throws [UnsupportedTemporalTypeError] if [field] is not supported.
  int get(ChronoField field);

  /// Returns a new instance of this [Temporal]
  /// with the given [amount] subtracted.
  ///
  /// Throws [UnsupportedTemporalTypeError] if [unit] is not supported.
  Temporal minus(int amountToAdd, ChronoUnit unit);

  /// Returns a new instance of this [Temporal]
  /// with the given [amount] added.
  ///
  /// Throws [UnsupportedTemporalTypeError] if [unit] is not supported.
  Temporal plus(int amount, ChronoUnit unit);

  /// Returns the difference in the given [unit] between this [Temporal]
  /// and [endExclusive].
  ///
  /// Calculates the number of whole units between the two temporals.
  ///
  /// If [endExclusive] is before this, the result will be negative.
  int until(Temporal endExclusive, ChronoUnit unit);

  /// Returns a new instance of this [Temporal]
  /// with the given [amount] added.
  ///
  /// Throws [UnsupportedTemporalTypeError] if the addition can not be made.
  Temporal operator +(TemporalAmount amount);

  /// Returns a new instance of this [Temporal]
  /// with the given [amount] subtracted.
  ///
  /// Throws [UnsupportedTemporalTypeError] if the addition can not be made.
  Temporal operator -(TemporalAmount amount);
}
