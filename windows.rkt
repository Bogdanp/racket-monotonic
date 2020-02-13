#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define
         racket/unsafe/ops)

(provide nanotime)

(when (< (system-type 'word) 64)
  (error 'monotonic "32bit Windows systems are not supported"))

(define (check r who)
  (when (zero? r)
    (error who "failed: ~a" r)))

(define-ffi-definer define-libc (ffi-lib "msvcrt.dll"))

(define-cstruct _LARGE_INTEGER
  ([QuadPart _int64]))

(define-libc QueryPerformanceCounter (_fun _LARGE_INTEGER-pointer
                                           -> (r : _int)
                                           -> (check r 'QueryPerformanceCounter)))

(define-libc QueryPerformanceFrequency (_fun _LARGE_INTEGER-pointer
                                             -> (r : _int)
                                             -> (check r 'QueryPerformanceFrequency)))

(define freq
  (let ([out (make-LARGE_INTEGER 0)])
    (QueryPerformanceFrequency out)
    (LARGE_INTEGER-QuadPart out)))

(define (nanotime)
  (define t (make-LARGE_INTEGER 0))
  (QueryPerformanceCounter t)
  (unsafe-fx*
   ;; microseconds
   (unsafe-fxquotient
    (unsafe-fx* (LARGE_INTEGER-QuadPart t) 1000000)
    freq)
   ;; nanoseconds
   1000))
