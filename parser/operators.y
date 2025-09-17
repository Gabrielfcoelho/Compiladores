%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUM POWER FLOOR_DIVIDE LESS_EQUAL MORE_EQUAL EQUAL DIFF PLUS MINUS TIMES DIVIDE MOD LESS MORE LPAREN RPAREN

%left PLUS MINUS
%left TIMES DIVIDE FLOOR_DIVIDE MOD
%right POWER 

%%

expressao:
      expressao POWER expressao
    | expressao FLOOR_DIVIDE expressao
    | expressao LESS_EQUAL expressao
    | expressao MORE_EQUAL expressao
    | expressao EQUAL expressao
    | expressao DIFF expressao
    | expressao PLUS expressao
    | expressao MINUS expressao
    | expressao TIMES expressao
    | expressao DIVIDE expressao
    | expressao MOD expressao
    | expressao LESS expressao
    | expressao MORE expressao
    | LPAREN expressao RPAREN
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