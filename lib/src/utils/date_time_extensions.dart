import '../local_date.dart';
import '../local_time.dart';

extension DateTimeExtensions on DateTime {
  LocalDate toLocalDate() => LocalDate(year, month, day);

  LocalTime toLocalTime() =>
      LocalTime(hour, minute, second, millisecond, microsecond);
}
