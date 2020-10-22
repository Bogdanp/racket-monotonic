#lang racket/base

(require racket/contract
         racket/runtime-path)

(provide
 current-monotonic-nanoseconds
 nanotime)

(define-runtime-module-path cs "cs.rkt")
(define-runtime-module-path macos "macos.rkt")
(define-runtime-module-path posix "posix.rkt")
(define-runtime-module-path windows "windows.rkt")

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
  (case (system-type 'vm)
    [(cs) (dynamic-require cs 'nanotime)]
    [else (case (system-type)
            [(windows) (dynamic-require windows 'nanotime)]
            [(macosx)  (dynamic-require macos 'nanotime)]
            [else      (dynamic-require posix 'nanotime)])]))

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
