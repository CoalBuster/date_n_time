import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'day_of_week.dart';
import 'temporal/chrono_field.dart';
import 'temporal/temporal.dart';

class WeekFields {
  final DayOfWeek firstDayOfWeek;

  WeekFields(this.firstDayOfWeek);

  factory WeekFields.of(Locale locale) {
    var longDateFormat =
        DateFormat.yMMMMEEEEd(Intl.canonicalizedLocale(locale.toString()));

    var firstDayOfWeek = DayOfWeek.of(
        (longDateFormat.dateSymbols.FIRSTDAYOFWEEK) % DateTime.daysPerWeek + 1);

    return WeekFields(firstDayOfWeek);
  }

  int firstDayOfWeekOffset(Temporal temporal) {
    var fdow = firstDayOfWeek.value;
    var isodow = temporal.get(ChronoField.dayOfWeek);
    var offset = (isodow - fdow) % DateTime.daysPerWeek;
    return offset;
  }
}
