#lang racket/base

(require ffi/unsafe/vm)

(provide
 nanotime)

(define-syntax-rule (define-primitives id ...)
  (begin (define id (vm-primitive 'id)) ...))

(define-primitives
  current-time
  time-second
  time-nanosecond)

(define (nanotime)
  (define t (current-time 'time-monotonic))
  (+ (* (time-second t) 1000000000) (time-nanosecond t)))
