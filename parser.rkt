#lang brag
libre-prog: libre-stmt*
@libre-stmt: /"[" [libre-print | libre-init | libre-while | libre-if] /"]" [/COM]
libre-print: /"print" libre-expr+
libre-init: /"init" libre-expr (",i" | ",s" | libre-expr)
libre-while: /"while" libre-expr libre-stmt+
libre-if: /"if" libre-expr libre-stmt [libre-stmt]
@libre-expr: libre-symbol | libre-bool | libre-arit
libre-bool: libre-expr ("==" | ">" | "<" | "!=") libre-expr
@libre-arit: libre-sum
libre-sum: [libre-sum ("+" | "-")] libre-prod
libre-prod: [libre-prod ("*" | "/")] libre-number
@libre-symbol: libre-number | STRING
@libre-number: libre-id | INTEGER
@libre-id: ID
