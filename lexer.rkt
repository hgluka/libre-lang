#lang racket
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev word (:+ (char-set "abcdefghijklmnoprstuvwxyz")))

(define libre-lexer
  (lexer-srcloc
    [(eof) (return-without-srcloc eof)]
    [whitespace (token lexeme #:skip? #t)]
    [(from/stop-before "//" "\n") (token 'COM lexeme)]
    [(:or "print" "init" "while" "if"
          "==" "!=" "<" ">" "+" "-" "*" "/" ",i" ",s"
          "[" "]") (token lexeme lexeme)]
    [digits (token 'INTEGER (string->number lexeme))]
    [(:or (from/to "\"" "\"") (from/to "'" "'"))
     (token 'STRING
            (substring lexeme
                       1 (sub1 (string-length lexeme))))]
    [word (token 'ID (string->symbol lexeme))]))

(provide libre-lexer)
