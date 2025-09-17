%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token STR FLOAT INT PLUS MINUS TIMES DIVIDE LPAREN RPAREN

%union {
    int intValue;
    float floatValue;
    char *stringValue;
}

%type <intValue> INT
%type <floatValue> FLOAT
%type <stringValue> STR

%%

expressao:
    expressao PLUS expressao
  | expressao MINUS expressao
  | expressao TIMES expressao
  | expressao DIVIDE expressao
  | LPAREN expressao RPAREN
  | expressao STR                      {printf("String lida: %s\n", $2);} 
  | expressao FLOAT                    {printf("FLOAT lido: %f\n", $2);}
  | expressao INT                      {printf("Inteiro lido: %d\n", $2);}
  | STR                                {printf("String lida: %s\n", $1);} 
  | FLOAT                              {printf("FLOAT lido: %f\n", $1);}
  | INT                                {printf("Inteiro lido: %d\n", $1);}
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}