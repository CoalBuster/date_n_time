abstract class TemporalUnit {}

enum ChronoUnit implements TemporalUnit {
  days,
  hours,
  milliseconds,
  seconds,
  minutes,
  months,
  years;
}
