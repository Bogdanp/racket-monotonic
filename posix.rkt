#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(provide nanotime)

(define CLOCK_MONOTONIC 1)

(define-ffi-definer define-libc (ffi-lib "libc.so.6"))

(define-cstruct _timespec
  ([tv_sec _long]
   [tv_nsec _long]))

(define-libc clock_gettime (_fun _int _timespec-pointer -> _int))

(define (nanotime)
  (define ts (make-timespec 0 0))
  (when (< (clock_gettime CLOCK_MONOTONIC ts) 0)
    (error 'nanotime))
  (+ (* (timespec-tv_sec ts) 1000000000)
     (timespec-tv_nsec ts)))
