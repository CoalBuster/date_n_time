import 'chrono_unit.dart';
import 'temporal.dart';

abstract interface class TemporalAmount {
  Temporal addTo(Temporal temporal);
  TemporalAmount minus(int amountToAdd, ChronoUnit unit);
  TemporalAmount plus(int amountToAdd, ChronoUnit unit);
  Temporal subtractFrom(Temporal temporal);
}
