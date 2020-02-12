#lang racket/base

(require racket/contract)

(provide
 current-monotonic-nanoseconds)

(define current-custom-monotonic-nanoseconds
  (make-parameter #f))

(define/contract current-monotonic-nanoseconds
  (parameter/c exact-nonnegative-integer?)
  (make-derived-parameter
   current-custom-monotonic-nanoseconds
   values
   (lambda (v)
     (if v v (nanotime)))))

(define nanotime
  (case (system-type)
    [(linux)  (dynamic-require "linux.rkt" 'nanotime)]
    [(macosx) (dynamic-require "macos.rkt" 'nanotime)]
    [else (error "~a is not currently supported" (system-type))]))

(module+ test
  (require rackunit)

  (void
   (for/fold ([t1 -1])
             ([_ (in-range 1000)])
     (define t2 (nanotime))
     (begin0 t2
       (check-true (> t2 t1)))))

  (parameterize ([current-monotonic-nanoseconds 0])
    (check-equal? (current-monotonic-nanoseconds) 0)))