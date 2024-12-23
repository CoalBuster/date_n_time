# Changelog

## 1.0.5

- Fixed a bug where `Temporal.atEndOfMonth()` would return a wrong result
  for dates near the end of the month, ironically.

## 1.0.4

- Updated `intl` dependency to version `>=0.19 <0.21.0`, fixing resolve issue for flutter.

## 1.0.3

- Improved package description.

## 1.0.2

- **New:** `WeekFields` - for localized week aspects.
- Added `atStartOfWeek(locale)` extension for `Temporal`.
- Added `of(int)` constructor for `DayOfWeek`.
- Added `value` property for `DayOfWeek`.
- Added `ofEpochDay(int)` constructor for `LocalDate`.
- Added `ChronoField.epochDay` adjust/get support for `LocalDate`.
- Added `fromMicrosecondsSinceEpoch(int, ZoneId)` constructor for `LocalDateTime`.
- Added `ofMicrosecondOfDay(int)` constructor for `LocalTime`.
- Added `ChronoField.microsecondOfDay` get support for `LocalTime`.
- Added `copyWith` method to `Period`.
- Added `fromMicrosecondsSinceEpoch(int, ZoneId)` constructor for `ZonedDateTime`.
- Added `copyWith` method to `ZonedDateTime`.
- Added `toLocalDateTime()` extension for `DateTime`.
- Added `toZonedDateTime()` extension for `DateTime`.
- Modified `LocalDate.from(Temporal)` to use `ChronoField.epochDay` instead of components.
- Modified `LocalTime.from(Temporal)` to use `ChronoField.microsecondOfDay` instead of components.
- Updated `intl` dependency to version `0.20.1`.
- Improved documentation coverage.

## 1.0.1

- Fixed missing exports.

## 1.0.0

- Initial release.
