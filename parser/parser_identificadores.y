%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NAME INVALID NUM PLUS MINUS TIMES DIVIDE LPAREN RPAREN

%%
programa:

  | programa identificadores   
  ;

identificadores:
    NAME {printf("Nome válido\n");}
  | expressao
  ;

expressao:
    expressao PLUS expressao
  | expressao MINUS expressao
  | expressao TIMES expressao
  | expressao DIVIDE expressao
  | LPAREN expressao RPAREN
  | NUM { printf("Numero lido\n"); }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
