%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

/* tipos para valores semânticos */
%union {
    int ival;
}

/* tokens e tipos */
%token <ival> NUM
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

/* tipo do não-terminal principal */
%type <ival> expressao

/* precedência */
%left PLUS MINUS
%left TIMES DIVIDE

%start expressao
%%

expressao:
    expressao PLUS expressao  { $$ = $1 + $3; }
  | expressao MINUS expressao { $$ = $1 - $3; }
  | expressao TIMES expressao { $$ = $1 * $3; }
  | expressao DIVIDE expressao
    {
        if ($3 == 0) {
            fprintf(stderr, "Erro: divisão por zero na linha %d\n", yylineno);
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
  | LPAREN expressao RPAREN   { $$ = $2; }
  | NUM                       { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext;
    fprintf(stderr, "Erro sintático na linha %d próximo a '%s': %s\n",
            yylineno, yytext ? yytext : "EOF", s);
}

int main(void) {
    return yyparse();
}
