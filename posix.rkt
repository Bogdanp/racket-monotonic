#lang racket/base

(require ffi/unsafe
         ffi/unsafe/atomic
         ffi/unsafe/define
         racket/unsafe/ops)

(provide nanotime)

(define CLOCK_MONOTONIC 1)

(define-ffi-definer define-libc (ffi-lib "libc.so.6"))

(define-cstruct _timespec
  ([tv_sec _long]
   [tv_nsec _long]))

(define-libc clock_gettime (_fun _int _timespec-pointer -> _int))

(define ts (make-timespec 0 0))

(define (nanotime)
  (start-atomic)
  (define res (clock_gettime CLOCK_MONOTONIC ts))
  (when (< res 0)
    (end-atomic)
    (error "nanotime: ~a" res))
  (begin0 (unsafe-fx+ (unsafe-fx* (timespec-tv_sec ts) 1000000000)
                      (timespec-tv_nsec ts))
    (end-atomic)))
