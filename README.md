# racket-monotonic

Monotonic times for racket.  Super alpha stuff.  Only macOS and Linux
are currently supported.

## Installation

    raco pkg install monotonic

## Usage

``` racket
(require monotonic)

;; Get the current monotonic clock in nanoseconds.
(current-monotonic-nanoseconds)
```

## License

    monotonic is licensed under the 3-Clause BSD license.
