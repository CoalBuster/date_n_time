import 'chrono_field.dart';
import 'chrono_unit.dart';
import 'temporal_amount.dart';

abstract interface class Temporal {
  Temporal adjust(ChronoField field, int newValue);
  int get(ChronoField field);
  Temporal minus(int amountToAdd, ChronoUnit unit);
  Temporal plus(int amountToAdd, ChronoUnit unit);
  int until(Temporal endExclusive, ChronoUnit unit);
  Temporal operator +(TemporalAmount amount);
  Temporal operator -(TemporalAmount amount);
}
