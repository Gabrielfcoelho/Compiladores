%{
#include "parser_keywords.tab.h"
%}

%%
"def"           { return DEF; }
"return"        { return RTRN; }
"if"            { return IF; }
"elif"          { return ELIF; }
"else"          { return ELSE; }
"while"         { return WHL; }
"break"         { return BRK; }
"False"         { return FLS; }
"True"          { return TRUE; }
"None"          { return NONE; }
"is"            { return IS; }
"and"           { return AND; }
"or"            { return OR; }
"not"           { return NOT; }



[0-9]+          { yylval = atoi(yytext); return NUM; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
[ \t\n]+        { /* Ignorar espaços em branco */ }
.               { printf("Caractere inválido: %s\n", yytext); }
%%
