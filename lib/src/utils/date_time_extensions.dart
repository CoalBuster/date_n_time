import '../day_of_week.dart';
import '../local_date.dart';
import '../local_time.dart';

extension DateTimeExtensions on DateTime {
  DayOfWeek get dayOfWeek {
    return switch (this.weekday) {
      DateTime.monday => DayOfWeek.monday,
      DateTime.tuesday => DayOfWeek.tuesday,
      DateTime.wednesday => DayOfWeek.wednesday,
      DateTime.thursday => DayOfWeek.thursday,
      DateTime.friday => DayOfWeek.friday,
      DateTime.saturday => DayOfWeek.saturday,
      DateTime.sunday => DayOfWeek.sunday,
      _ => throw UnimplementedError(),
    };
  }

  LocalDate toLocalDate() => LocalDate(year, month, day);

  LocalTime toLocalTime() =>
      LocalTime(hour, minute, second, millisecond, microsecond);
}
