#lang racket
(require libre-lang/parser libre-lang/tokenizer brag/support rackunit rackunit/text-ui)

(define str #<<HERE
[init foo ,i] // Komentar
[init bar foo+5]
[print foo bar]
[while bar > 0 [init bar bar-1]]
[if bar == 1 [print bar] [print "bar nije 1"]]
HERE
)

#;(parse-to-datum (apply-tokenizer make-tokenizer str))
(check-equal? (parse-to-datum (apply-tokenizer make-tokenizer str))
                '(libre-prog
                  (libre-init foo ",i")
                  (libre-init bar (libre-arit foo "+" 5))
                  (libre-print foo bar)
                  (libre-while
                   (libre-bool bar ">" 0)
                   (libre-init bar (libre-arit bar "-" 1)))
                  (libre-if
                   (libre-bool bar "==" 1)
                   (libre-print bar)
                   (libre-print "bar nije 1"))))
