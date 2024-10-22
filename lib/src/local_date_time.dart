class LocalDateTime {
  static final _format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSS');

  final DateTime _internal;

  LocalDate._(this._internal);

  LocalDate.of(DateTime value)
      : this._(DateTime.utc(value.year, value.month, value.day));

  LocalDate.fromString(String value) : this._(_format.parse(value, true));

  int get weekday => _internal.weekday;

  operator >=(LocalDate other) => isAfter(other) || isAtSameMomentAs(other);

  operator <=(LocalDate other) => isBefore(other) || isAtSameMomentAs(other);

  LocalDate add({
    int days = 0,
  }) {
    var duration = Duration(
      days: days,
    );
    return LocalDate._(_internal.add(duration));
  }

  int compareTo(LocalDate other) => _internal.compareTo(other._internal);

  Duration difference(LocalDate other) => _internal.difference(other._internal);

  String format(DateFormat dateFormat) => dateFormat.format(_internal);

  bool isAfter(LocalDate other) => _internal.isAfter(other._internal);

  bool isAtSameMomentAs(LocalDate other) =>
      _internal.isAtSameMomentAs(other._internal);

  bool isBefore(LocalDate other) => _internal.isBefore(other._internal);

  DateTime toLocalDateTime() =>
      DateTime(_internal.year, _internal.month, _internal.day);

  @override
  String toString() => _format.format(_internal);

  DateTime toUtcDateTime() =>
      DateTime.utc(_internal.year, _internal.month, _internal.day);
}

extension LocalDateTime on DateTime {
  LocalDate toLocalDate() => LocalDate.of(this);
  LocalDateRange toLocalDateRange(DateTime other) =>
      LocalDateRange(start: toLocalDate(), end: other.toLocalDate());
}
