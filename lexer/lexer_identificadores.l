%{
#include "parser_identificadores.tab.h"
%}

%%

[_a-zA-Z][_0-9a-zA-Z]* { return NAME; }

[0-9]+          { yylval = atoi(yytext); return NUM; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
[ \t\n]+        { /* Ignorar espaços em branco */ }

%%
