#lang racket

(provide libre-init
         libre-print
         libre-while
         libre-if
         libre-sum
         libre-prod
         libre-bool
         #%top-interaction
         #%app
         #%datum
         (rename-out [libre-module-begin #%module-begin]))

(define-syntax (libre-sum caller-stx)
  (syntax-case caller-stx ()
    [(libre-sum x) (syntax-protect (syntax/loc caller-stx x))]
    [(libre-sum x "+" y) (syntax-protect (syntax/loc caller-stx (+ x y)))]
    [(libre-sum x "-" y) (syntax-protect (syntax/loc caller-stx (- x y)))]
    [else
     (syntax-protect (raise-syntax-error
      'sum-error
      (format "wrong operator in: ~a" caller-stx)))]))

(define-syntax (libre-prod caller-stx)
  (syntax-case caller-stx ()
    [(libre-prod x) (syntax-protect (syntax/loc caller-stx x))]
    [(libre-prod x "*" y) (syntax-protect (syntax/loc caller-stx (* x y)))]
    [(libre-prod x "/" y) (syntax-protect (syntax/loc caller-stx (/ x y)))]
    [else
     (syntax-protect (raise-syntax-error
                      'prod-error
                      (format "wrong operator in: ~a" caller-stx)))]))

(define-syntax (libre-bool caller-stx)
  (syntax-case caller-stx ()
    [(libre-bool x "==" y) (syntax-protect (syntax/loc caller-stx (eq? x y)))]
    [(libre-bool x "!=" y) (syntax-protect (syntax/loc caller-stx (not (eq? x y))))]
    [(libre-bool x ">" y) (syntax-protect (syntax/loc caller-stx (> x y)))]
    [(libre-bool x "<" y) (syntax-protect (syntax/loc caller-stx (< x y)))]
    [else
     (syntax-protect (raise-syntax-error
      'bool-error
      (format "wrong operator in: ~a" caller-stx)))]))

(define-syntax (libre-init caller-stx)
  (syntax-case caller-stx ()
    [(libre-init id ",s") (syntax-protect (syntax/loc caller-stx
                           (set! id (read-line (current-input-port) 'any))))]
    [(libre-init id ",i") (syntax-protect (syntax/loc caller-stx
                           (set! id (inexact->exact
                                       (string->number
                                        (read-line (current-input-port) 'any))))))]
    [(libre-init id expo) (syntax-protect (syntax/loc caller-stx
                             (set! id expo)))]
    [else
     (syntax-protect (raise-syntax-error
      'init-error
      (format "wrong calling patern in: ~a" caller-stx)))]))

(define-syntax (libre-print caller-stx)
  (syntax-case caller-stx ()
    [(libre-print) (syntax-protect (syntax/loc caller-stx (void)))]
    [(libre-print x y ...) (syntax-protect (syntax/loc caller-stx
                             (begin
                               (displayln x)
                               (libre-print y ...))))]
    [else
     (syntax-protect (raise-syntax-error
      'print-error
      (format "wrong calling pattern in: ~a" caller-stx)))]))

(define-syntax (libre-while caller-stx)
  (syntax-case caller-stx ()
    [(libre-while test stmts ...) (syntax-protect (syntax/loc caller-stx
                                                    (let loop ()
                                                      (when test
                                                        stmts ...
                                                        (loop)))))]
    [else
     (syntax-protect (raise-syntax-error
      'while-error
      (format "wrong calling pattern in: ~a" caller-stx)))]))

(define-syntax (libre-if caller-stx)
  (syntax-case caller-stx ()
    [(libre-if test s1) (syntax-protect (syntax/loc caller-stx
                                          (if test s1 '())))]
    [(libre-if test s1 s2) (syntax-protect (syntax/loc caller-stx
                             (if test s1 s2)))]
    [else
     (syntax-protect (raise-syntax-error
      'if-error
      (format "wrong calling pattern in: ~a" caller-stx)))]))



(define-syntax (libre-module-begin caller-stx)
  (syntax-case caller-stx ()
    [(libre-module-begin (libre-prog stmts ...))
     (with-syntax ([(ids ...) (find-unique-ids #'(stmts ...))])
     #'(#%module-begin
      (define ids 0) ...
      (begin stmts ...)))]))

(begin-for-syntax
  (require racket/list)
  (define (syntax-flatten stx)
    (let* ([stx-unwrapped (syntax-e stx)]
           [maybe-pair (and (pair? stx-unwrapped) (flatten stx-unwrapped))])
      (if maybe-pair
          (append-map syntax-flatten maybe-pair)
          (list stx))))

  (define (find-unique-ids stmts)
    (remove-duplicates
     (for/list ([stx (in-list (syntax-flatten stmts))]
                #:when (syntax-property stx 'libre-id))
       stx)
     #:key syntax->datum)))
