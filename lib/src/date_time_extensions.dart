extension DateTimeExtensions on DateTime {
  DateTime toUtcDateTime() =>
      DateTime.utc(_internal.year, _internal.month, _internal.day);
  DateTime toLocalDateTime() =>
      DateTime(_internal.year, _internal.month, _internal.day);
}
