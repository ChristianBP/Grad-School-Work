type token =
  | LPAREN
  | RPAREN
  | SEMICOLON
  | ASSIGN
  | LEQ
  | OR
  | AND
  | NOT
  | PLUS
  | MINUS
  | TIMES
  | EOF
  | SKIP
  | IF
  | THEN
  | ELSE
  | WHILE
  | DO
  | TRUE
  | FALSE
  | INT
  | BOOL
  | NUM of (
# 27 "simplparser.mly"
       int
# 28 "simplparser.mli"
)
  | VAR of (
# 28 "simplparser.mly"
       string
# 33 "simplparser.mli"
)

val parse_cmd :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Simpltypes.icmd
