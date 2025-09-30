%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUM PLUS MINUS TIMES DIVIDE LPAREN RPAREN RCBRACKET LCBRACKET RSBRACKET LSBRACKET COLON COMA

%%

expressao:
    expressao PLUS expressao
  | expressao MINUS expressao
  | expressao TIMES expressao
  | expressao DIVIDE expressao
  | LPAREN expressao RPAREN
  | LCBRACKET expressao RCBRACKET
  | LSBRACKET expressao RSBRACKET
  | COMA expressao
  | COLON
  | NUM
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
