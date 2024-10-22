import 'temporal_unit.dart';

abstract class Temporal {
  Temporal _plus(int amountToAdd, TemporalUnit unit);
}
