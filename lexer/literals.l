%{
#include "literals.tab.h"
%}

%%

(\".*?\")|(\'.*?\')                       {   
                                            size_t len = strlen(yytext);
                                            char *str = (char*)malloc(len - 1); // len-2 para conteúdo, +1 para '\0'
                                            strncpy(str, yytext + 1, len - 2);
                                            str[len - 2] = '\0';
                                            yylval.stringValue = str;
                                            return STR; 
                                        }
[+-]?(0\.[0-9]*|[1-9][0-9]*\.[0-9]*)    { yylval.floatValue = atof(yytext); return FLOAT; }
[+-]?(0+|[1-9][0-9]*)                   { yylval.intValue = atoi(yytext); return INT; }
"+"                                     { return PLUS; }
"-"                                     { return MINUS; }
"*"                                     { return TIMES; }
"/"                                     { return DIVIDE; }
"("                                     { return LPAREN; }
")"                                     { return RPAREN; }
[ \t\n]+                                { /* Ignorar espaços em branco */ }
.                                       { printf("Caractere inválido: %s\n", yytext); }

%%