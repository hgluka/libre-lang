#lang racket
(require libre-lang/lexer brag/support rackunit)

(define (lex str)
  (apply-lexer libre-lexer str))

(check-equal? (lex "") empty)

(check-equal?
  (lex "// comment\n")
  (list (srcloc-token (token 'COM "// comment")
                      (srcloc 'string #f #f 1 10))
        (srcloc-token (token "\n" #:skip? #t)
                      (srcloc 'string #f #f 11 1))))

(check-equal?
  (lex "print")
  (list (srcloc-token (token "print" "print")
                      (srcloc 'string #f #f 1 5))))

(check-equal?
  (lex "42")
  (list (srcloc-token (token 'INTEGER 42)
                      (srcloc 'string #f #f 1 2))))

(check-equal?
  (lex "\"Zdravo svete!\"")
  (list (srcloc-token (token 'STRING "Zdravo svete!")
                      (srcloc 'string #f #f 1 15))))

(check-equal?
  (lex "identifier")
  (list (srcloc-token (token 'ID 'identifier)
                      (srcloc 'string #f #f 1 10))))
