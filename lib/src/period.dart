/// A date-based amount of time in the ISO-8601 calendar system, such as '2 years, 3 months and 4 days'.
class Period implements Comparable<Period> {
  final int days;
  final int months;
  final int years;

  const Period({
    this.days = 0,
    this.months = 0,
    this.years = 0,
  });

  Period operator +(Period other) => plus(
        days: other.days,
        months: other.months,
        years: other.years,
      );

  Period operator -(Period other) => minus(
        days: other.days,
        months: other.months,
        years: other.years,
      );

  Period minus({
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

  Period plus({
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

  /// Compares this [Period] to [other], returning zero if the values are equal.
  ///
  /// Returns a negative integer if this [Period] is shorter than
  /// [other], or a positive integer if it is longer.
  ///
  /// A negative [Period] is always considered shorter than a positive one.
  ///
  /// It is always the case that `period1.compareTo(period2) < 0` iff
  /// `(someDate + period1).compareTo(someDate + period2) < 0`.
  int compareTo(Period other) {
    final yearCompare = years.compareTo(other.years);

    if (yearCompare != 0) {
      return yearCompare;
    }

    final monthsCompare = months.compareTo(other.months);

    if (monthsCompare != 0) {
      return monthsCompare;
    }

    return days.compareTo(other.days);
  }
}
