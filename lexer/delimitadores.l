%{
#include "parser.tab.h"
%}

%%

[0-9]+          { yylval = atoi(yytext); return NUM; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LCBRACKET; }
"}"             { return RCBRACKET; }
"["             { return LSBRACKET; }
"]"             { return RSBRACKET; }
":"             { return COLON; }
","             { return COMA; }
[ \t\n]+        { /* Ignorar espaços em branco */ }
.               { printf("Caractere inválido: %s\n", yytext); }

%%
