#lang s-exp "colors.rkt"
rgb

(require "rgb-base.rkt")

(define fire #:color red (expt 2 34))
(define tree #:color green (sqrt fire))
(define ice #:color blue (/ fire tree))

(display fire)
(display (format "~n"))

;; `colors' is implicitly defined and exported
