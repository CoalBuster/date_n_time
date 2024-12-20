import 'package:intl/intl.dart';

import 'day_of_week.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';
import 'utils/date_time_extensions.dart';

/// A date without a time-zone, such as July 20, 1969.
class LocalDate implements Comparable<LocalDate>, Temporal {
  /// The date at the start of the epoch year, '1970-01-01'.
  static final LocalDate epoch = LocalDate(1970, 1, 1);

  final DateTime _internal;

  /// Constructs a new [LocalDate] instance from components,
  /// like year, month and day.
  LocalDate(int year, [int month = 1, int dayOfMonth = 1])
      : _internal = DateTime.utc(year, month, dayOfMonth);

  /// Constructs a new [LocalDate] instance
  /// from the given temporal.
  ///
  /// Relies on precense of [ChronoField.epochDay].
  ///
  /// Throws [UnsupportedTemporalTypeError] if unable to convert.
  factory LocalDate.from(Temporal temporal) {
    if (temporal is LocalDate) {
      return temporal.copyWith();
    }

    final epochDay = temporal.get(ChronoField.epochDay);
    return LocalDate.ofEpochDay(epochDay);
  }

  /// Constructs a new [LocalDate] instance with current date
  /// in the local timezone.
  ///
  /// ```dart
  /// final now = LocalDate.now();
  /// ```
  factory LocalDate.now() {
    final dateTime = DateTime.now();
    return LocalDate(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Constructs a new [LocalDate] instance
  /// with the given [epochDay] count.
  factory LocalDate.ofEpochDay(int epochDay) {
    return epoch.copyWith(dayOfMonth: epochDay);
  }

  /// Constructs a new [LocalDate] instance based on [formattedString].
  ///
  /// Throws a [FormatException] if the input string cannot be parsed.
  ///
  /// The function parses a subset of ISO 8601,
  /// which includes the subset accepted by RFC 3339.
  ///
  /// Examples of accepted strings:
  ///
  /// * `"2012-02-27"`
  /// * `"20120227"`
  /// * `"+20120227"`
  /// * `"-123450101"`: in the year -12345.
  factory LocalDate.parse(String formattedString) {
    var dateTime = DateTime.parse(formattedString);
    return LocalDate(dateTime.year, dateTime.month, dateTime.day);
  }

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int get dayOfMonth => _internal.day;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => _internal.dayOfWeek;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = LocalDate.parse('1969-07-20');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => _internal.month;

  /// The year.
  ///
  /// ```dart
  /// final moonLanding = LocalDate.parse('1969-07-20');
  /// print(moonLanding.year); // 1969
  /// ```
  int get year => _internal.year;

  /// The proleptic month. Count of months since year 0.
  int get prolepticMonth => year * DateTime.monthsPerYear + month - 1;

  /// The epoch-day. Count of days since epoch (1970-01-01).
  int get epochDay => _internal.difference(epoch._internal).inDays;

  /// Returns true if year is a leap year.
  ///
  /// This implements the Gregorian calendar leap year rules wherein
  /// a year is considered to be a leap year if it is divisible by 4,
  /// excepting years divisible by 100, but including years divisible by 400.
  ///
  /// This function assumes the use of the Gregorian calendar
  /// or the proleptic Gregorian calendar.
  bool get isLeapYear =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LocalDate && other._internal.isAtSameMomentAs(_internal);
  }

  @override
  int get hashCode => _internal.hashCode;

  /// Whether this [LocalDate] occurs before [other].
  bool operator <(LocalDate other) => _internal.isBefore(other._internal);

  /// Whether this [LocalDate] occurs after [other].
  bool operator >(LocalDate other) => _internal.isAfter(other._internal);

  /// Whether this [LocalDate] occurs before or at the same moment as [other].
  bool operator <=(LocalDate other) =>
      _internal.isBefore(other._internal) ||
      _internal.isAtSameMomentAs(other._internal);

  /// Whether this [LocalDate] occurs after or at the same moment as [other].
  bool operator >=(LocalDate other) =>
      _internal.isAfter(other._internal) ||
      _internal.isAtSameMomentAs(other._internal);

  @override
  LocalDate operator +(TemporalAmount amount) =>
      amount.addTo(this) as LocalDate;

  @override
  LocalDate operator -(TemporalAmount amount) =>
      amount.subtractFrom(this) as LocalDate;

  @override
  LocalDate adjust(ChronoField field, int newValue) {
    return switch (field) {
      ChronoField.year => copyWith(year: newValue),
      ChronoField.month => copyWith(month: newValue),
      ChronoField.dayOfMonth => copyWith(dayOfMonth: newValue),
      ChronoField.epochDay => LocalDate.ofEpochDay(newValue),
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  int get(ChronoField field) {
    return switch (field) {
      ChronoField.year => year,
      ChronoField.month => month,
      ChronoField.dayOfMonth => dayOfMonth,
      ChronoField.dayOfWeek => dayOfWeek.value,
      ChronoField.epochDay => epochDay,
      ChronoField.prolepticMonth => prolepticMonth,
      _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
    };
  }

  @override
  LocalDate minus(int amountToSubtract, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => copyWith(year: year - amountToSubtract),
      ChronoUnit.months => copyWith(month: month - amountToSubtract),
      ChronoUnit.weeks => copyWith(
          dayOfMonth: dayOfMonth - amountToSubtract * DateTime.daysPerWeek),
      ChronoUnit.days => copyWith(dayOfMonth: dayOfMonth - amountToSubtract),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  LocalDate plus(int amountToAdd, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => copyWith(year: year + amountToAdd),
      ChronoUnit.months => copyWith(month: month + amountToAdd),
      ChronoUnit.weeks =>
        copyWith(dayOfMonth: dayOfMonth + amountToAdd * DateTime.daysPerWeek),
      ChronoUnit.days => copyWith(dayOfMonth: dayOfMonth + amountToAdd),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  int until(Temporal endExclusive, ChronoUnit unit) {
    return switch (unit) {
      ChronoUnit.years => _monthsUntil(endExclusive) ~/ DateTime.monthsPerYear,
      ChronoUnit.months => _monthsUntil(endExclusive),
      ChronoUnit.weeks => _daysUntil(endExclusive) ~/ DateTime.daysPerWeek,
      ChronoUnit.days => _daysUntil(endExclusive),
      _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
    };
  }

  @override
  int compareTo(LocalDate other) => _internal.compareTo(other._internal);

  /// Returns a new instance of this [LocalDate]
  /// with the given individual properties adjusted.
  ///
  /// The [copyWith] method creates a new [LocalDate] object with values
  /// for the properties [LocalDate.year], [LocalDate.dayOfMonth], etc,
  /// provided by similarly named arguments, or using the existing value
  /// of the property if no argument, or `null`, is provided.
  ///
  /// Example:
  /// ```dart
  /// final now = LocalDate.now();
  /// final sameDateInMoonLandingYear =
  ///     now.copyWith(year: 1969);
  /// ```
  ///
  /// Property values are allowed to overflow or underflow the range
  /// of the property (like a [month] outside the 1 to 12 range),
  /// which can affect the more significant properties
  /// (for example, a month of 13 will result in the month of January
  /// of the next year.)
  LocalDate copyWith({
    int? year,
    int? month,
    int? dayOfMonth,
  }) {
    return LocalDate(
      year ?? this.year,
      month ?? this.month,
      dayOfMonth ?? this.dayOfMonth,
    );
  }

  /// Returns a string representing this [LocalDate],
  /// formatted according to the given [format].
  String format(DateFormat format) => format.format(_internal);

  @override
  String toString() {
    String y = (year >= -9999 && year <= 9999)
        ? year.toString().padLeft(4, '0')
        : year.toString().padLeft(6, '0');
    String m = month.toString().padLeft(2, '0');
    String d = dayOfMonth.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  int _daysUntil(Temporal endExclusive) {
    return endExclusive.get(ChronoField.epochDay) - epochDay;
  }

  int _monthsUntil(Temporal endExclusive) {
    var totalMonths =
        endExclusive.get(ChronoField.prolepticMonth) - prolepticMonth;
    final days = endExclusive.get(ChronoField.dayOfMonth) - dayOfMonth;

    if (totalMonths > 0 && days < 0) {
      totalMonths--;
    } else if (totalMonths < 0 && days > 0) {
      totalMonths++;
    }

    return totalMonths;
  }
}
