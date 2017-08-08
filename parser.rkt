#lang brag
libre-prog: libre-stmt*
@libre-stmt: /"[" [libre-print | libre-init | libre-while | libre-if] /"]" [/COM]
libre-print: /"print" libre-expr+
libre-init: /"init" libre-expr (",i" | ",s" | libre-expr)
libre-while: /"while" libre-expr libre-stmt+
libre-if: /"if" libre-expr libre-stmt [libre-stmt]
@libre-expr: libre-symbol | libre-bool | libre-arit
libre-bool: libre-expr ("==" | ">" | "<" | "!=") libre-expr
libre-arit: libre-expr ("+" | "-" | "*" | "/") libre-expr
@libre-symbol: libre-id | INTEGER | STRING
@libre-id: ID
