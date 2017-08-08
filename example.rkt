#lang libre-lang
[print "Upisite broj:"] // Ovaj program izracunava faktorijal broja sa standardnog ulaza
[init foo ,i]
[init bar foo-1]
[if foo > 0 [while bar > 0
                   [init foo foo*bar]
                   [init bar bar-1]]
    [print ""]]
[if foo > 0 [print foo] [print "Broj je manji od 0"]]
