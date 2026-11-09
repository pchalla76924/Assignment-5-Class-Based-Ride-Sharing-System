# Assignment 5 — Class Based Ride Sharing System


## Files

- `main.cpp`: C++17 implementation.
- `RideSharing.st`: GNU Smalltalk 3.2.5 file-in implementation and demonstration.
- `tests.cpp`, `tests.st`: automated functional checks.
- `*_output.txt`, `*_tests.txt`: actual execution and test records.


## C++

```sh
g++ -std=c++17 -Wall -Wextra -Werror -pedantic main.cpp -o rides
./rides
g++ -std=c++17 -Wall -Wextra -Werror -pedantic tests.cpp -o rides-tests
./rides-tests
```

## GNU Smalltalk

```sh
gst --no-user-files RideSharing.st
gst --no-user-files RideSharing.st tests.st
```

The verification environment used GNU Smalltalk 3.2.5 with a relocated image:
`gst --no-user-files -I <runtime>/gst.im RideSharing.st`.
The runtime's library path was configured for that local installation. A normal installation uses the commands above. Other Smalltalk dialects may require file-in changes.

GNU Smalltalk may return exit status zero after reporting a language-level error; confirm that output has the final PASS line and contains no error trace. The included verification records were checked for both.

## Behavior

Standard fare: $3 + $2/mile. Premium fare: $7 + $3.50/mile.
The demonstration prices rides at $13 and $35 and reports earnings of $48.
Driver.addRide records a completed ride; Rider.requestRide records a requested ride. No separate dispatch or trip lifecycle is implemented. Smalltalk uses scaled decimal literals for the premium rate and sample rating to provide stable decimal output. Histories remain internal; clients can request counts and earnings.


