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

  /// A constant for a period of zero.
  static const Period zero = Period(days: 0);

  /// Constructs a new [Period] instance from components.
  ///
  /// All arguments are 0 by default.
  ///
  /// ```dart
  /// const period = Period(years: 2, months: 8, days: 1);
  /// print(period); // P2Y8M1D
  /// ```
  const Period({
    int days = 0,
    int months = 0,
    int years = 0,
  })  : _days = days,
        _months = months,
        _years = years;

  /// Creates a new [Period] instance consisting of the number of years,
  /// months and days between [startInclusive] and [endExclusive].
  factory Period.between(Temporal startInclusive, Temporal endExclusive) {
    int totalMonths = 0;

    try {
      totalMonths = startInclusive.until(endExclusive, ChronoUnit.months);
      startInclusive = startInclusive.plus(totalMonths, ChronoUnit.months);
    } on UnsupportedTemporalTypeError {
      // Months not supported. Calculate pure day-difference instead.
    }

    final days = startInclusive.until(endExclusive, ChronoUnit.days);
    final years = totalMonths ~/ DateTime.monthsPerYear;
    final months = totalMonths.remainder(DateTime.monthsPerYear);
    return Period(years: years, months: months, days: days);
  }

  /// Adds this [Period] and [other] and
  /// returns the sum as a new [Period] object.
  Period operator +(Period other) => Period(
        years: years + other.years,
        months: months + other.months,
        days: days + other.days,
      );

  /// Subtracts [other] from this [Period] and
  /// returns the difference as a new [Period] object.
  Period operator -(Period other) => Period(
        years: years - other.years,
        months: months - other.months,
        days: days - other.days,
      );

  /// Creates a new [Period] with the opposite direction of this [Period].
  ///
  /// The returned [Period] has the same length as this one, but will have the
  /// opposite sign (as reported by [isNegative]) as this one where possible.
  Period operator -() => Period(
        years: 0 - years,
        months: 0 - months,
        days: 0 - days,
      );

  /// The years unit of this [Period].
  int get years => _years;

  /// The months unit of this [Period].
  int get months => _months;

  /// The days unit of this [Period].
  int get days => _days;

  /// The total number of months in this [Period].
  int get totalMonths => _years * DateTime.monthsPerYear + _months;

  /// Whether this [Period] is negative.
  ///
  /// A negative [Period] represents the difference from a later date to an
  /// earlier date.
  bool get isNegative => years < 0 || months < 0 || days < 0;

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
  Period minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => copyWith(years: years - amountToSubtract),
      ChronoUnit.months => copyWith(months: months - amountToSubtract),
      ChronoUnit.weeks =>
        copyWith(days: days - amountToSubtract * DateTime.daysPerWeek),
      ChronoUnit.days => copyWith(days: days - amountToSubtract),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  Period plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => copyWith(years: years + amountToAdd),
      ChronoUnit.months => copyWith(months: months + amountToAdd),
      ChronoUnit.weeks =>
        copyWith(days: days + amountToAdd * DateTime.daysPerWeek),
      ChronoUnit.days => copyWith(days: days + amountToAdd),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
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

  /// Returns a new instance of this [Period]
  /// with the given individual properties adjusted.
  ///
  /// The specified properties are adjusted to the given new value.
  /// Properties that are not specified or `null` remain unaffected.
  ///
  /// Note that the resulting [Period] is not normalized.
  /// That is, '15 months' is different to '1 year and 3 months'.
  ///
  /// ```dart
  /// final period = Period(years: 1, months: 3)
  /// print(period.copyWith(months: 15)); // P1Y15M
  /// ```
  Period copyWith({
    int? years,
    int? months,
    int? days,
  }) {
    return Period(
      years: years ?? this.years,
      months: months ?? this.months,
      days: days ?? this.days,
    );
  }
}
