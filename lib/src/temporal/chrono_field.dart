enum ChronoField {
  /// The proleptic year, such as `2012`.
  year,

  /// The month `[1..12]`.
  month,

  /// The day of the month `[1..31]`.
  dayOfMonth,

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  hourOfDay,

  /// The minute of the hour `[0...59]`.
  minute,

  /// The second of minute `[0...59]`.
  second,

  /// The millisecond of second `[0...999]`.
  millisecond,

  /// The microsecond of millisecond `[0...999]`.
  microsecond,

  /// The day of the week `[1..7]`.
  /// Values from Monday (1) to Sunday (7).
  dayOfWeek,

  /// The epoch-day. Count of days since epoch (1970-01-01).
  epochDay,

  /// The microsecond of day.
  microsecondOfDay,

  /// The proleptic month. Count of months since year 0.
  prolepticMonth,

  /// The offset in seconds from UTC.
  offsetSeconds,
}
