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
  | FUN
  | MAPSTO
  | COMMA
  | LBRACE
  | RBRACE
  | NUM of (
# 31 "simplparser.mly"
       int
# 33 "simplparser.mli"
)
  | VAR of (
# 32 "simplparser.mly"
       string
# 38 "simplparser.mli"
)

val parse_cmd :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Simpltypes.icmd
