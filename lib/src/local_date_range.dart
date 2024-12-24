import 'local_date.dart';
import 'period.dart';
import 'temporal/chrono_unit.dart';

class LocalDateRange {
  /// The start of the range of dates.
  final LocalDate start;

  /// The end of the range of dates.
  final LocalDate end;

  /// Creates a date range for the given start and end [DateTime].
  LocalDateRange(this.start, this.end) : assert(start >= end);

  Period get period => start == end ? Period.zero : Period.between(start, end);

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
      start == other || end == other || start < other && end > other;

  LocalDateRange? intersect(LocalDateRange other) {
    if (!intersects(other)) {
      return null;
    }

    var left = start > other.start ? start : other.start;
    var right = end < other.end ? end : other.end;
    return LocalDateRange(left, right);
  }

  bool intersects(LocalDateRange other) =>
      start == other.start ||
      start == other.end ||
      end == other.start ||
      end == other.end ||
      start > other.start && start < other.end ||
      end > other.start && end < other.end ||
      start < other.start && end > other.end;

  Iterable<LocalDate> toLocalDates() sync* {
    for (var date = start; date <= end; date = date.plus(1, ChronoUnit.days)) {
      yield date;
    }
  }
}
