%{
#include "operators.tab.h"
%}

%%

[0-9]+          { yylval = atoi(yytext); return NUM; }
"**"            { return POWER; }
"//"            { return FLOOR_DIVIDE; }
"+"             { return PLUS; }
"<="            { return LESS_EQUAL; }
">="            { return MORE_EQUAL; }
"=="            { return EQUAL; }
"!="            { return DIFF; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"%"             { return MOD; }
"<"             { return LESS; }
">"             { return MORE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
[ \t\n]+        { /* Ignorar espaços em branco */ }
.               { printf("Caractere inválido: %s\n", yytext); }

%%