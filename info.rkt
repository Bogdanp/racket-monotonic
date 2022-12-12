#lang info

(define license 'BSD-3-Clause)
(define collection "monotonic")
(define version "0.1.1")
(define deps '("base"))
(define build-deps '("racket-doc"
                     "rackunit-lib"
                     "scribble-lib"))
(define scribblings '(("monotonic.scrbl")))
(define test-omit-paths '("macos.rkt" "posix.rkt" "windows.rkt"))
