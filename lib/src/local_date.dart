import 'package:date_n_time/src/date_time_format.dart';
import 'package:date_n_time/src/day_of_week.dart';
import 'package:date_n_time/src/period.dart';
import 'package:date_n_time/src/temporal/temporal_amount.dart';
import 'package:intl/intl.dart';

class LocalDate {
  final DateTime _internal;

  /// Obtains an instance of LocalDate from a year, month and day.
  LocalDate.of(int year, int month, int dayOfMonth)
      : _internal = DateTime.utc(year, month, dayOfMonth);

  /// Obtains the current date from the system clock in the default time-zone.
  factory LocalDate.now() {
    final dateTime = DateTime.now();
    return LocalDate.of(dateTime.year, dateTime.day, dateTime.day);
  }

  /// Obtains an instance of [LocalDate] from a text string such as 2024-10-22.
  /// The text is parsed using the given [format], returning a date.
  /// If [format] is absent, the text is parsed using [DateTimeFormat.ISO_LOCAL_DATE].
  factory LocalDate.parse(String value, [DateFormat? format]) {
    format ??= DateTimeFormat.ISO_LOCAL_DATE;
    var dateTime = format.parse(value, true);
    return LocalDate.of(dateTime.year, dateTime.month, dateTime.day);
  }

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int get dayOfMonth => _internal.day;

  /// The day of the week `[monday..sunday]`.
  DayOfWeek get dayOfWeek => DayOfWeek.from(_internal);

  operator >=(LocalDate other) => isAfter(other) || isAtSameMomentAs(other);

  operator <=(LocalDate other) => isBefore(other) || isAtSameMomentAs(other);

LocalDate add(TemporalAmount amountToAdd){
amountToAdd.addTo()
}

  LocalDate plus({
    int days = 0,
    int months = 0,
    int years = 0,
  }) {
    var duration = Duration(
      days: days,
    );
    return LocalDate._(_internal.add(duration));
  }

  LocalDate atEndOfMonth([int monthsDiff = 0]) => LocalDate._(
      DateTime.utc(_internal.year, _internal.month + 1 + monthsDiff, 0));

  LocalDate atStartOfMonth([int monthsDiff = 0]) => LocalDate._(
      DateTime.utc(_internal.year, _internal.month + monthsDiff, 1));

  int compareTo(LocalDate other) => _internal.compareTo(other._internal);

  Duration difference(LocalDate other) => _internal.difference(other._internal);

  String format(DateFormat format) => format.format(_internal);

  bool isAfter(LocalDate other) => _internal.isAfter(other._internal);

  bool isAtSameMomentAs(LocalDate other) =>
      _internal.isAtSameMomentAs(other._internal);

  bool isBefore(LocalDate other) => _internal.isBefore(other._internal);

  LocalDate subtract({
    int days = 0,
    int months = 0,
  }) {
    var duration = Duration(
      days: days,
    );
    return LocalDate._(_internal.subtract(duration));
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LocalDate && other._internal == _internal;
  }

  @override
  int get hashCode => _internal.hashCode;

  @override
  String toString() => format(DateTimeFormat.ISO_LOCAL_DATE);
}
