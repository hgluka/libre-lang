#lang racket
(require libre-lang/parser libre-lang/tokenizer brag/support rackunit rackunit/text-ui)

(define str #<<HERE
[init foo ,i] // Komentar
[init bar foo+5*foo/1-1]
[print foo bar]
[while bar > 0 [init bar bar-1]]
[if bar == 1 [print bar] [print "bar nije 1"]]
HERE
)

#;(parse-to-datum (apply-tokenizer make-tokenizer str))
(check-equal? (parse-to-datum (apply-tokenizer make-tokenizer str))
                '(libre-prog
                  (libre-init foo ",i")
                  (libre-init bar (libre-sum
                                   (libre-sum
                                    (libre-sum
                                     (libre-prod foo)) "+"
                                    (libre-prod
                                     (libre-prod
                                      (libre-prod 5) "*" foo) "/" 1)) "-"
                                      (libre-prod 1)))
                  (libre-print foo bar)
                  (libre-while
                   (libre-bool bar ">" 0)
                   (libre-init bar (libre-sum (libre-sum (libre-prod bar)) "-" (libre-prod 1))))
                  (libre-if
                   (libre-bool bar "==" 1)
                   (libre-print bar)
                   (libre-print "bar nije 1"))))
