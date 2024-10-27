# dart_n_time

A dart package extending `DateTime` to ease date or time representation and calculation.

When only needing to work with dates and/or times, using dart's `DateTime` can be tricky.  
That is because, unless specifically constructed using `.utc()`,  
it will take the timezone of the system, meaning additions and subtractions of time  
become subject to the rules of the timezone the application is running in.

This package is heavily inspired by Java's solution to this: `java.time`.  
A delicate balance has been searched between dart's existing classes and new ones.

## Features

| `date_n_time` | `dart`   | Description                             | Example           |
| :------------ | :------- | :-------------------------------------- | :---------------- |
| LocalDate     | -        | Date-only                               | 2024-10-26        |
| LocalTime     | -        | Time-only                               | 10:30             |
| LocalDateTime | -        | Date + Time, without Zone               | 2024-10-26 10:30  |
| ZonedDateTime | DateTime | Date + Time + Zone, Interchangeable     | 2024-10-26 10:30Z |
| Period        | -        | Length in Years, Months and Days        | P1Y2M3D           |
| TimeSpan      | Duration | Length in Microseconds, Interchangeable | 01:02:03.456      |

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

See the `/example` folder.

## Additional information

This is a hobby project. Support can not be guaranteed.  
Feedback is welcome.
