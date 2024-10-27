import 'chrono_field.dart';
import 'chrono_unit.dart';
import 'temporal.dart';

extension TemporalAdjusters on Temporal {
  Temporal toFirstDayOfMonth() => this.adjust(ChronoField.dayOfMonth, 1);
  Temporal toLastDayOfMonth() =>
      this.plus(1, ChronoUnit.months).adjust(ChronoField.dayOfMonth, 0);
}
