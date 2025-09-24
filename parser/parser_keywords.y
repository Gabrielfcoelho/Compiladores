%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token DEF RTRN IF ELIF ELSE WHL BRK FLS TRUE NONE IS AND OR NOT 
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN NUM

%%

programa:

  | programa declaracao_composta
  ;

declaracao_composta:
    decl_if
  | decl_else
  | decl_elif  
  | decl_while
  | funcao
  | declaracao_simples
  | expressao
  ;


declaracao_simples:
    expressao
  | decl_rtrn
  | decl_and
  | decl_or
  | decl_not
  | decl_brk
  | decl_fls
  | decl_true
  | decl_none
  ;


expressao:
    expressao PLUS expressao
  | expressao MINUS expressao
  | expressao TIMES expressao
  | expressao DIVIDE expressao
  | LPAREN expressao RPAREN
  | NUM
  ;


decl_if: IF {printf("recebi um if\n");}
decl_else: ELSE {printf("recebi um else\n");}
decl_elif: ELIF {printf("recebi um elif\n");}
decl_while: WHL {printf("recebi um while\n");}
funcao: DEF {printf("recebi um def\n");}

decl_rtrn: RTRN {printf("recebi um return\n");};
decl_and: AND {printf("recebi um and\n");}
decl_or: OR {printf("recebi um or\n");}
decl_not: NOT {printf("recebi um not\n");}
decl_brk: BRK {printf("recebi um break\n");}
decl_fls: FLS {printf("recebi um False\n");}
decl_true: TRUE {printf("recebi um True\n");}
decl_none: NONE {printf("recebi um None\n");}
%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
