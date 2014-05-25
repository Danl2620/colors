#lang racket

;; Provides a variant of `define' that expects a `#:color' spec,
;; and injects a `colors' definition into the module that maps
;; every defined name (in symbol form) to a color (also a symbol).
;; The `colors' id is also automatically `provide'd.

(provide (except-out (all-from-out racket)
                     #%module-begin
                     define)
         (rename-out [color-define define]
                     [color-module-begin #%module-begin]))

(define-syntax (color-module-begin stx)
  (syntax-case stx ()
    [(_ name form ...)
	 #'(#%module-begin
		;; original forms:
		form ...
		;; put at end, so that it's expanded after all
		;; other top-level definitions:
		(define-colors name))]))

;; (define-syntax (color-module-begin stx)
;;   (syntax-case stx ()
;;     [(_ name form ...)
;;      (with-syntax ([colors-id
;;                     ;; non-hygenic binding:
;;                     (datum->syntax stx (syntax->datum #'name))]

;; 				   )
;;        #'(#%module-begin
;;           ;; original forms:
;;           form ...
;;           ;; put at end, so that it's expanded after all
;;           ;; other top-level definitions:
;;           (define-colors colors-id)))]))

(begin-for-syntax
 (define id-to-color (make-hasheq)))

;; (define-syntax-rule (color-define color-id #:color color expr)
;;   (begin
;;     (begin-for-syntax
;;      ;; Register in compile-time mapping
;;      (hash-set! id-to-color 'color-id 'color))
;;     ;; Otherwise, act like regular `define':
;;     (define color-id expr)))

 (define-syntax (color-define stx)
   (syntax-case stx ()
     [(_ color-id #:color color expr)
      (begin
        ;; Register in compile-time mapping
        (hash-set! id-to-color (syntax-e #'color-id) (syntax-e #'color))
        ;; Otherwise, act like regular `define':
        #'(define color-id expr))]))

(define-syntax (define-colors stx)
  (syntax-case stx ()
    [(_ id)
     #`(begin
         (define id
           ;; turn hash table into literal hash table:
           '#,(datum->syntax #f id-to-color))
         ;; Automatically provide it:
         (provide id))]))
