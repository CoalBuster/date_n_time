import '../date_n_time.dart';

class LocalDateRange {
  /// The start of the range of dates.
  final LocalDate start;

  /// The end of the range of dates.
  final LocalDate end;

  /// Creates a date range for the given start and end [DateTime].
  LocalDateRange({
    required this.start,
    required this.end,
  }) : assert(!start.isAfter(end));

  int get durationInDays => end.difference(start).inDays;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LocalDateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';

  bool contains(LocalDate other) =>
      start.isAtSameMomentAs(other) ||
      end.isAtSameMomentAs(other) ||
      start.isBefore(other) && end.isAfter(other);

  LocalDateRange? intersect(LocalDateRange other) {
    if (!intersects(other)) {
      return null;
    }

    var left = start.isAfter(other.start) ? start : other.start;
    var right = end.isBefore(other.end) ? end : other.end;
    return LocalDateRange(start: left, end: right);
  }

  bool intersects(LocalDateRange other) =>
      start.isAtSameMomentAs(other.start) ||
      start.isAtSameMomentAs(other.end) ||
      end.isAtSameMomentAs(other.start) ||
      end.isAtSameMomentAs(other.end) ||
      start.isAfter(other.start) && start.isBefore(other.end) ||
      end.isAfter(other.start) && end.isBefore(other.end) ||
      start.isBefore(other.start) && end.isAfter(other.end);

  Iterable<LocalDate> toLocalDates() sync* {
    for (var date = start; date <= end; date = date.add(days: 1)) {
      yield date;
    }
  }
}
