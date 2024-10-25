import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

/// A date-based amount of time in the ISO-8601 calendar system,
/// such as '2 years, 3 months and 4 days'.
class Period implements TemporalAmount {
  final int _days;
  final int _months;
  final int _years;

  static const Period zero = Period(days: 0);

  const Period({
    int days = 0,
    int months = 0,
    int years = 0,
  })  : _days = days,
        _months = months,
        _years = years;

  factory Period.between(Temporal startInclusive, Temporal endExclusive) {
    int totalMonths = 0;

    try {
      totalMonths = startInclusive.until(endExclusive, ChronoUnit.months);
      startInclusive = startInclusive.plus(totalMonths, ChronoUnit.months);
    } on UnsupportedTemporalTypeError {}

    final days = startInclusive.until(endExclusive, ChronoUnit.days);
    final years = totalMonths ~/ DateTime.monthsPerYear;
    final months = totalMonths.remainder(DateTime.monthsPerYear);
    return Period(years: years, months: months, days: days);
  }

  /// Adds this Period and [other] and
  /// returns the sum as a new Period object.
  Period operator +(Period other) => add(
        days: other.days,
        months: other.months,
        years: other.years,
      );

  /// Subtracts [other] from this Period and
  /// returns the difference as a new Period object.
  Period operator -(Period other) => subtract(
        days: other.days,
        months: other.months,
        years: other.years,
      );

  /// The years unit of this [Period].
  int get years => _years;

  /// The months unit of this [Period].
  int get months => _months;

  /// The days unit of this [Period].
  int get days => _days;

  /// Whether this [Period] is equal [other].
  ///
  /// Periods are equal if all components are individually equal,
  /// as reported by [years], [months] and [days].
  /// Note that this means that a period of "15 Months" is not equal
  /// to a period of "1 Year and 3 Months".
  @override
  bool operator ==(Object other) =>
      other is Period &&
      _years == other._years &&
      _months == other._months &&
      _days == other._days;

  @override
  int get hashCode => Object.hash(_years, _months, _days);

  @override
  Temporal addTo(Temporal temporal) {
    if (_years != 0) {
      temporal = temporal.plus(_years, ChronoUnit.years);
    }

    if (_months != 0) {
      temporal = temporal.plus(_months, ChronoUnit.months);
    }

    if (_days != 0) {
      temporal = temporal.plus(_days, ChronoUnit.days);
    }

    return temporal;
  }

  @override
  Temporal subtractFrom(Temporal temporal) {
    if (_years != 0) {
      temporal = temporal.minus(_years, ChronoUnit.years);
    }

    if (_months != 0) {
      temporal = temporal.minus(_months, ChronoUnit.months);
    }

    if (_days != 0) {
      temporal = temporal.minus(_days, ChronoUnit.days);
    }

    return temporal;
  }

  /// Returns a copy of this [Period] with the specified units subtracted.
  Period subtract({
    int days = 0,
    int months = 0,
    int years = 0,
  }) {
    return Period(
      days: this.days - days,
      months: this.months - months,
      years: this.years - years,
    );
  }

  /// Returns a copy of this [Period] with the specified units added.
  Period add({
    int days = 0,
    int months = 0,
    int years = 0,
  }) {
    return Period(
      days: this.days + days,
      months: this.months + months,
      years: this.years + years,
    );
  }

  /// Returns a string representation of this [Period].
  ///
  /// Returns a string with years, months and days, in the
  /// following format: `P<years>Y<months>M<days>D`. For example,
  /// ```dart
  /// var d = const Duration(years: 1, months: 2, days: 3);
  /// print(d.toString()); // P1Y2M3D
  /// ```
  ///
  /// A zero period will be represented as zero days, `P0D`.
  @override
  String toString() {
    if (this == zero) {
      return 'P0D';
    }

    final yearsText = _years == 0 ? '' : 'Y$_years';
    final monthsText = _months == 0 ? '' : 'M$_months';
    final daysText = _days == 0 ? '' : 'D$_days';

    return 'P$yearsText$monthsText$daysText';
  }
}
