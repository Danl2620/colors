#lang racket
;;(require "rgb.rkt")

;; Show what the "colors.rkt" language generated for "rgb.rkt":
;;colors
(define (read-rgb names)
  (map (compose (lambda (name)
				  (cons name (dynamic-require (format "~a.rkt" name) name)))
				string->symbol)
	   names))

(provide main)
(define (main . args)
  (command-line #:program "show-rgb"
				#:argv args
				#:args params
				(read-rgb params)))