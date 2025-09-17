%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%option yylineno

%%

[0-9]+          { yylval = atoi(yytext); return NUM; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }

[ \t]+          { /* Ignorar espaços em branco */ }

/* Contador de linhas */
(\r\n|\r|\n)+   { int i; for (i = 0; yytext[i]; ++i) if (yytext[i] == '\n') ++yylineno; }

"#"[^\r\n]*     { /* Ignorar comentário de linha */ }
.               { printf("Aviso lexical: Caractere inválido '%s' na linha '%d'\n", yytext, yylineno); }

%%