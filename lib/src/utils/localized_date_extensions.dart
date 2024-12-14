import 'package:intl/locale.dart';

import '../temporal/chrono_unit.dart';
import '../temporal/temporal.dart';
import '../week_fields.dart';

extension LocalizedDateExtensions<T extends Temporal> on T {
  T atStartOfWeek(Locale locale) {
    var offset = WeekFields.of(locale).firstDayOfWeekOffset(this);
    return this.minus(offset, ChronoUnit.days) as T;
  }
}
