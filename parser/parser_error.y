%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

/* union para valores */
%union{int yylval;}

/*Declarar tokens e seus tipos*/
%token<yylval>NUM
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN
%token<yylval>NUM

/*Regras de associatividade */
%left PLUS MINUS 
%left TIMES DIVIDE

%start expressao
%%

expressao:
    expressao PLUS expressao {$$ = $1 + $3; }
  | expressao MINUS expressao {$$ = $1 - $3; } 
  | expressao TIMES expressao {$$ = $1 * $3; }
  | expressao DIVIDE expressao
        if ($3 == 0) {
            fprintf(stderr, "Erro de matemática burro, pode dividir por 0 não man\n");
            $$ = 0;
        }
        else {
            $$ = $1 / $3;
        }
  | LPAREN expressao RPAREN {$$ = $2; }
  | NUM {$$ = $1; }
  ;

%%

void yyerror(const char *s) {
    extern int yylineno;
    extern char *yytext
    fprintf(stderr, "Erro sintático na linha %d próximo a '%s' : '%s'\n", yylineno, yytext ? yytext : "EOF" s);
}

int main(void) {
    yyparse();
    return 0;
}
