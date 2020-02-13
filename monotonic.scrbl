#lang scribble/manual

@(require (for-label monotonic
                     racket/base))

@title{@exec{monotonic}: monotonic clock for Racket}
@author[(author+email "Bogdan Popa" "bogdan@defn.io")]
@defmodule[monotonic]

This module provides a monotonic clock on POSIX systems that support
@exec{CLOCK_MONOTONIC}, macOS and 64bit Windows.

@defparam[current-monotonic-nanoseconds nanotime exact-nonnegative-integer?]{
  A monotonically-increasing value in nanoseconds since some
  unspecified time in the past.
}

@defproc[(nanotime) exact-nonnegative-integer?]{
  Returns a monotonically-increasing value in nanoseconds since some
  unspecified time in the past.

  Use this over the parameter if you need absolutely minimal overhead.
  It is 1.5x to 2x slower than @racket[current-inexact-milliseconds]
  depending on the platform.
}
