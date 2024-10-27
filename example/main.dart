import 'package:date_n_time/date_n_time.dart';

void main() {
  // LocalDate (date only)
  var currentDate = LocalDate.now();
  var specificDate = LocalDate(2024, 10, 26);
  var parsedDate = LocalDate.parse('2024-10-26');

  print(currentDate); // The current local date as yyyy-MM-dd
  print(parsedDate == specificDate); // true
  print(parsedDate.year); // 2024
  print(parsedDate.month); // 10
  print(parsedDate.dayOfMonth); // 26
  print(parsedDate.dayOfWeek); // DayOfWeek.saturday
  print(parsedDate.isLeapYear); // true
  print(parsedDate.toString()); // 2024-10-26

  // LocalTime (time only)
  var currentTime = LocalTime.now();
  var specificTime = LocalTime(10, 30, 15);
  var parsedTime = LocalTime.parse('10:30:15');

  print(currentTime); // The current local time as hh:mm:ss.mmm[uuu]
  print(parsedTime == specificTime); // true
  print(parsedTime.hour); // 10
  print(parsedTime.minute); // 30
  print(parsedTime.second); // 15
  print(parsedTime.millisecond); // 0
  print(parsedTime.microsecond); // 0
  print(parsedTime.toString()); // 10:30:15.000

  // LocalDateTime (date and time only)
  var currentDateTime = LocalDateTime.now();
  var specificDateTime = LocalDateTime(specificDate, specificTime);
  var parsedDateTime = LocalDateTime.parse('2024-10-26T10:30:15');

  print(currentDateTime); // The current dateTime as <date>T<time>
  print(parsedDateTime == specificDateTime); // true
  print(parsedDateTime.year); // 2024
  print(parsedDateTime.month); // 10
  print(parsedDateTime.dayOfMonth); // 26
  print(parsedDateTime.dayOfWeek); // DayOfWeek.saturday
  print(parsedDateTime.isLeapYear); // true
  print(parsedDateTime.hour); // 10
  print(parsedDateTime.minute); // 30
  print(parsedDateTime.second); // 15
  print(parsedDateTime.millisecond); // 0
  print(parsedDateTime.microsecond); // 0
  print(parsedDateTime.toString()); // 2024-10-26T10:30:15.000

  // ZonedDateTime (datetime with zone)
  var currentZonedTime = ZonedDateTime.now(ZoneId.system);
  var specificZonedTime = ZonedDateTime(specificDateTime, ZoneId.utc);
  var parsedZonedTime = ZonedDateTime.parse('2024-10-26T10:30:15Z');

  print(currentZonedTime); // The current dateTime as <date>T<time>[Z]
  print(parsedZonedTime == specificZonedTime); // true
  print(parsedZonedTime.year); // 2024
  print(parsedZonedTime.month); // 10
  print(parsedZonedTime.day); // 26
  print(parsedZonedTime.dayOfWeek); // DayOfWeek.saturday
  print(parsedZonedTime.isLeapYear); // true
  print(parsedZonedTime.hour); // 10
  print(parsedZonedTime.minute); // 30
  print(parsedZonedTime.second); // 15
  print(parsedZonedTime.millisecond); // 0
  print(parsedZonedTime.microsecond); // 0
  print(parsedZonedTime.zone); // ZoneId.utc
  print(parsedZonedTime.offsetSeconds); // 0
  print(parsedZonedTime.toString()); // 2024-10-26T10:30:15.000Z
}
