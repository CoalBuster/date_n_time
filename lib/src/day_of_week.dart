/// A day-of-week, such as 'Tuesday'.
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  const DayOfWeek();

  /// Obtains an instance of DayOfWeek from a temporal object.
  factory DayOfWeek.from(DateTime temporal) {
    return switch (temporal.weekday) {
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
}
