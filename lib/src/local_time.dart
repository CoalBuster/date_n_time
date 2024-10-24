import 'package:intl/intl.dart';

import 'date_time_format.dart';
import 'day_of_week.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';
import 'temporal/temporal_amount.dart';
import 'temporal/unsupported_temporal_type_error.dart';

class LocalTime {
//implements Comparable<LocalTime>, Temporal {
  final Duration _internal;

  /// Obtains an instance of LocalDate from a year, month and day.
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

  /// Obtains the current date from the system clock in the default time-zone.
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

//   /// Obtains an instance of [LocalDate] from a text string such as 2024-10-22.
//   /// The text is parsed using the given [format], returning a date.
//   /// If [format] is absent, the text is parsed using [DateTimeFormat.ISO_LOCAL_DATE].
//   factory LocalTime.parse(String value, [DateFormat? format]) {
//     format ??= DateTimeFormat.ISO_LOCAL_DATE;
//     var dateTime = format.parse(value, true);
//     return LocalTime(dateTime.year, dateTime.month, dateTime.day);
//   }

  int get hour => _internal.inHours;

  int get minute =>
      _internal.inMinutes - _internal.inHours * Duration.minutesPerHour;

  int get seconds =>
      _internal.inSeconds - _internal.inMinutes * Duration.secondsPerMinute;

//   /// The day of the month `[1..31]`.
//   ///
//   /// ```dart
//   /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
//   /// print(moonLanding.day); // 20
//   /// ```
//   int get dayOfMonth => _internal.day;

//   /// The day of the week `[monday..sunday]`.
//   DayOfWeek get dayOfWeek => _internal.dayOfWeek;

//   /// The month `[1..12]`.
//   ///
//   /// ```dart
//   /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
//   /// print(moonLanding.month); // 7
//   /// assert(moonLanding.month == DateTime.july);
//   /// ```
//   int get month => _internal.month;

//   /// The year.
//   ///
//   /// ```dart
//   /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
//   /// print(moonLanding.year); // 1969
//   /// ```
//   int get year => _internal.year;

//   int get epochDay =>
//       _internal.microsecondsSinceEpoch ~/ Duration.microsecondsPerDay;

//   @override
//   bool operator ==(Object other) {
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     return other is LocalTime && other._internal.isAtSameMomentAs(_internal);
//   }

//   @override
//   int get hashCode => _internal.hashCode;

//   /// Whether this [LocalTime] occurs before [other].
//   bool operator <(LocalTime other) => _internal.isBefore(other._internal);

//   /// Whether this [LocalTime] occurs after [other].
//   bool operator >(LocalTime other) => _internal.isAfter(other._internal);

//   /// Whether this [LocalTime] occurs before or at the same moment as [other].
//   bool operator <=(LocalTime other) =>
//       _internal.isBefore(other._internal) ||
//       _internal.isAtSameMomentAs(other._internal);

//   /// Whether this [LocalTime] occurs after or at the same moment as [other].
//   bool operator >=(LocalTime other) =>
//       _internal.isAfter(other._internal) ||
//       _internal.isAtSameMomentAs(other._internal);

//   @override
//   LocalTime operator +(TemporalAmount amount) =>
//       amount.addTo(this) as LocalTime;

//   @override
//   LocalTime operator -(TemporalAmount amount) =>
//       amount.subtractFrom(this) as LocalTime;

//   @override
//   LocalTime adjust(ChronoField field, int newValue) {
//     return switch (field) {
//       ChronoField.year => _with(year: newValue),
//       ChronoField.month => _with(month: newValue),
//       ChronoField.dayOfMonth => _with(dayOfMonth: newValue),
//       _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
//     };
//   }

//   @override
//   int get(ChronoField field) {
//     return switch (field) {
//       ChronoField.year => year,
//       ChronoField.month => month,
//       ChronoField.dayOfMonth => dayOfMonth,
//       ChronoField.epochDay => epochDay,
//       _ => throw UnsupportedTemporalTypeError('Unsupported field: $field'),
//     };
//   }

//   @override
//   LocalTime minus(int amountToSubtract, ChronoUnit unit) {
//     return switch (unit) {
//       ChronoUnit.years => _with(year: year - amountToSubtract),
//       ChronoUnit.months => _with(month: month - amountToSubtract),
//       ChronoUnit.weeks => _with(dayOfMonth: dayOfMonth - amountToSubtract * 7),
//       ChronoUnit.days => _with(dayOfMonth: dayOfMonth - amountToSubtract),
//       _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
//     };
//   }

//   @override
//   LocalTime plus(int amountToAdd, ChronoUnit unit) {
//     return switch (unit) {
//       ChronoUnit.years => _with(year: year - amountToAdd),
//       ChronoUnit.months => _with(month: month - amountToAdd),
//       ChronoUnit.weeks => _with(dayOfMonth: dayOfMonth - amountToAdd * 7),
//       ChronoUnit.days => _with(dayOfMonth: dayOfMonth - amountToAdd),
//       _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
//     };
//   }

//   @override
//   int until(Temporal endExclusive, ChronoUnit unit) {
//     return switch (unit) {
//       ChronoUnit.years => _monthsUntil(endExclusive) ~/ DateTime.monthsPerYear,
//       ChronoUnit.months => _monthsUntil(endExclusive),
//       ChronoUnit.weeks => _daysUntil(endExclusive) ~/ DateTime.daysPerWeek,
//       ChronoUnit.days => _daysUntil(endExclusive),
//       _ => throw UnsupportedTemporalTypeError('Unsupported unit: $unit'),
//     };
//   }

//   @override
//   int compareTo(LocalTime other) => _internal.compareTo(other._internal);

//   String format(DateFormat format) => format.format(_internal);

//   @override
//   String toString() => format(DateTimeFormat.ISO_LOCAL_DATE);

//   int _daysUntil(Temporal endExclusive) {
//     return endExclusive.get(ChronoField.epochDay) - epochDay;
//   }

//   int _monthsUntil(Temporal endExclusive) {
//     final endProlepticMonth =
//         endExclusive.get(ChronoField.year) * DateTime.monthsPerYear +
//             endExclusive.get(ChronoField.month) -
//             1;
//     final startProlepticMonth = year * DateTime.monthsPerYear + month - 1;
//     var totalMonths = endProlepticMonth - startProlepticMonth;
//     final days = endExclusive.get(ChronoField.dayOfMonth) - dayOfMonth;

//     if (totalMonths > 0 && days < 0) {
//       totalMonths--;
//     } else if (totalMonths < 0 && days > 0) {
//       totalMonths++;
//     }

//     return totalMonths;
//   }

//   LocalTime _with({
//     int? year,
//     int? month,
//     int? dayOfMonth,
//   }) {
//     return LocalTime(
//       year ?? this.year,
//       month ?? this.month,
//       dayOfMonth ?? this.dayOfMonth,
//     );
//   }
}
