#lang racket/base

(require ffi/unsafe
         ffi/unsafe/define)

(provide nanotime)

(define-ffi-definer define-libc (ffi-lib "libc"))

(define-cstruct _mach_timebase_info_data
  ([numer _uint32]
   [denom _uint32]))

(define-libc mach_timebase_info (_fun _mach_timebase_info_data-pointer -> _void))
(define-libc mach_absolute_time (_fun -> _uint64))

(define info (make-mach_timebase_info_data 0 0))
(mach_timebase_info info)

(define numer (mach_timebase_info_data-numer info))
(define denom (mach_timebase_info_data-denom info))

(define (nanotime)
  (* (/ (mach_absolute_time) denom) numer))
