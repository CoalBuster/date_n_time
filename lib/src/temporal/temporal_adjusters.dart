import 'chrono_field.dart';
import 'chrono_unit.dart';
import 'temporal.dart';

extension TemporalAdjusters<T extends Temporal> on T {
  /// Returns a new instance of this [Temporal] at the end of the month.
  ///
  /// ```dart
  /// final date = LocalDate.parse('2024-10-26')
  /// print(date.atEndOfMonth()) // 2024-10-31
  /// ```
  T atEndOfMonth() {
    var plusMonth = this.plus(1, ChronoUnit.months);
    var newVal = plusMonth.adjust(ChronoField.dayOfMonth, 0);
    return newVal as T;
  }

  /// Returns a new instance of this [Temporal] at the start of the month.
  ///
  /// ```dart
  /// final date = LocalDate.parse('2024-10-26')
  /// print(date.atStartOfMonth()) // 2024-10-01
  /// ```
  T atStartOfMonth() {
    var newVal = this.adjust(ChronoField.dayOfMonth, 1);
    return newVal as T;
  }
}
