import 'temporal.dart';

abstract interface class TemporalAmount {
  Temporal addTo(Temporal temporal);
  Temporal subtractFrom(Temporal temporal);
}
