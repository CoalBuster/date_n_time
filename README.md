# date_n_time

A dart package extending `DateTime` to ease date or time representation and calculation.

When only needing to work with dates and/or times, using dart's `DateTime` can be tricky.  
That is because, unless specifically constructed using `.utc()`,  
it will take the timezone of the system, meaning additions and subtractions of time  
become subject to the rules of the timezone the application is running in.

This package is heavily inspired by Java's solution to this: `java.time`.  
A delicate balance has been searched between dart's existing classes and new ones.

## Features

The library makes a distinction between two types of objects:

- `Temporal`: A moment in time, such as a date.
- `TemporalAmount`: An amount of time, such as "6 hours".

Main `Temporal` implementations:

| Class         | Dart equivalent | Description                         | Example           |
| :------------ | :-------------- | :---------------------------------- | :---------------- |
| LocalDate     | n/a             | Date-only, without Zone             | 2024-10-26        |
| LocalTime     | n/a             | Time-only, without Zone             | 10:30             |
| LocalDateTime | n/a             | Date + Time, without Zone           | 2024-10-26 10:30  |
| ZonedDateTime | DateTime        | Date + Time + Zone, Interchangeable | 2024-10-26 10:30Z |

Main `TemporalAmount` implementations:

| Class    | Dart equivalent | Description                             | Example      |
| :------- | :-------------- | :-------------------------------------- | :----------- |
| Period   | n/a             | Length in Years, Months and Days        | P1Y2M3D      |
| TimeSpan | Duration        | Length in Microseconds, Interchangeable | 01:02:03.456 |

### The curious case of "days"

When wanting to add a couple of days to, for example, a `ZonedDateTime`,  
you will find there are two equally valid ways to do so:

- Add/Subtract days using `Period(days: n)`
- Add/Subtract days using `TimeSpan(days: n)`

There is a subtle, but important difference between the two implementations.  
The former tries to increase/decrease the `day`, without touching the `time`.  
The latter however tries to increase/decrease the `time` by **24 hours** per day.

Although adding a full day of hours may work fine in most cases,  
it becomes tricky whenever a **time-zone** change occurs.  
Suddenly, a "full" day is actually 23 or 25 hours of length, potentially causing unexpected behavior.

Be aware of this behavior when choosing your method of calculation.  
This only affects `Temporal` object that store a time-zone (e.g. `ZonedDateTime`).

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

See the `/example` folder.

## Notes

The native `DateTime` currently has no concept of time-zones other than `utc` and `system`.  
As the purpose of this package is merely to expand on what already exists,  
handling different time-zones other than those two is considered out-of-scope.

## Additional information

This is a hobby project. Support can not be guaranteed.  
Feedback is welcome.
