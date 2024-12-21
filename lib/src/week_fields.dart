import 'package:intl/intl.dart';

import 'day_of_week.dart';
import 'temporal/chrono_field.dart';
import 'temporal/chrono_unit.dart';
import 'temporal/temporal.dart';

/// Localized definitions of week-related aspects.
class WeekFields {
  /// The first day-of-week.
  final DayOfWeek firstDayOfWeek;

  /// Constructs a new [WeekFields].
  const WeekFields(this.firstDayOfWeek);

  /// Constructs a new [WeekFields] based on the given [locale].
  factory WeekFields.of(String locale) {
    var longDateFormat = DateFormat.yMMMMEEEEd(locale.toString());

    var firstDayOfWeek = DayOfWeek.of(
        (longDateFormat.dateSymbols.FIRSTDAYOFWEEK) % DateTime.daysPerWeek + 1);

    return WeekFields(firstDayOfWeek);
  }

  /// Gets the offset in days of the given [temporal]'s day-of-week
  /// relative to the localized first day of the week.
  /// That is, when the first day-of-week is Sunday, then that will return 0,
  /// with the other days ranging from Monday as 1 to Saturday as 6.
  ///
  /// ```dart
  /// var weekFields = const WeekFields(DayOfWeek.sunday);
  /// var date = LocalDate.parse('2024-10-26')
  /// print(weekFields.firstDayOfWeekOffset(date)); // 5
  /// ```
  int firstDayOfWeekOffset(Temporal temporal) {
    var fdow = firstDayOfWeek.value;
    var isodow = temporal.get(ChronoField.dayOfWeek);
    var offset = (isodow - fdow) % DateTime.daysPerWeek;
    return offset;
  }
}

/// Extensions for localized calculations on [Temporal].
extension TemporalWeekFields<T extends Temporal> on T {
  /// Returns a new instance of this [Temporal] at the start of the week.
  ///
  /// The first day-of-week varies by culture. For example, the US uses Sunday,
  /// while France and the ISO-8601 standard use Monday.
  /// If [locale] is not specified, the default locale is assumed.
  ///
  /// ```dart
  /// final date = LocalDate.parse('2024-10-26');
  /// print(Intl.getCurrentLocale()) // en_US
  /// print(date.atStartOfWeek()) // 2024-10-20
  /// ```
  T atStartOfWeek([String? locale]) {
    locale ??= Intl.getCurrentLocale();
    var culture = WeekFields.of(locale);
    var offset = culture.firstDayOfWeekOffset(this);
    return this.minus(offset, ChronoUnit.days) as T;
  }
}
