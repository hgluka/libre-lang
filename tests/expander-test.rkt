#lang racket
(require libre-lang/expander rackunit)

;; arithmetic tests
(check-equal?
 (libre-sum 1 "+" 2)
 (+ 1 2))
(check-equal?
 (libre-prod 2 "*" 3)
 (* 2 3))

(check-equal?
 (libre-sum (libre-sum (libre-sum (libre-prod 7)) "+" (libre-prod (libre-prod (libre-prod 5) "*" 7) "/" 1)) "-" (libre-prod 1))
 (- (+ 7 (/ (* 5 7) 1)) 1))

;; boolean tests
(check-equal?
 (libre-bool 12 "==" 5)
 #f)

;; statement tests
(let ([foo 0])
  (libre-init foo 5)
  (check-equal?
     foo 5))

(let ([foo 5])
  (libre-while
   (libre-bool foo ">" 0)
   (libre-init foo (libre-sum (libre-prod foo) "-" (libre-prod 1))))
  (check-equal?
   foo 0))

(check-equal?
 (libre-if
  (libre-bool 5 ">" 0)
  42 24)
 42)
