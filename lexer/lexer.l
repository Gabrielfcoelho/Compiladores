%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Pilha de tokens pendentes */
#define PENDING_MAX 128
static int pending_tokens[PENDING_MAX];
static int pending_top = 0;

/* Pilha de níveis de indentação */
#define INDENT_MAX 256
static int indent_stack[INDENT_MAX];
static int indent_top = 0;

void scanner_init(void);

static void push_token(int tok) {
    if (pending_top >= PENDING_MAX) {
        fprintf(stderr, "Erro: Pilha de tokens pendentes cheia.\n");
        exit(1);
    }
    pending_tokens[pending_top++] = tok;
}

static int pop_token(void) {
    if (pending_top == 0) return 0;
    return pending_tokens[--pending_top];
}

static int count_indent(const char *s) {
    int n = 0;
    for (; *s; ++s) {
        if (*s == ' ') n += 1;
        else if (*s == '\t') n += 8 - (n % 8);
        else break;
    }
    return n;
}
%}

%x INDENT_CHECK

%option yylineno
%option noyywrap

%%
%{
    /* Se tivermos um token pendente, o retornamos imediatamente */
    int pending = pop_token();
    if (pending) {
        return pending;
    }
%}
\n+             { BEGIN(INDENT_CHECK); }
<INDENT_CHECK>[ \t]* {
    if (yytext[yyleng-1] == '\n' || *yytext == '#') {
        yyless(0); 
        BEGIN(INITIAL);
        return NEWLINE;
    }

    int current_indent = count_indent(yytext);
    int previous_indent = indent_stack[indent_top - 1];

    if (current_indent > previous_indent) {
        if (indent_top >= INDENT_MAX) {
            fprintf(stderr, "Erro: Nível máximo de indentação excedido.\n");
            exit(1);
        }
        indent_stack[indent_top++] = current_indent;
        push_token(INDENT);
    } else {
        while (current_indent < indent_stack[indent_top - 1]) {
            indent_top--;
            push_token(DEDENT);
        }
        if (current_indent != indent_stack[indent_top - 1]) {
            fprintf(stderr, "Erro de Indentação na linha %d: nível inconsistente.\n", yylineno);
            exit(1);
        }
    }
    
    yyless(strlen(yytext));
    BEGIN(INITIAL);
    
    int t = pop_token();
    if (t) return t;
    
    return NEWLINE;
}

<INDENT_CHECK><<EOF>> {
    return 0;
}

^[ \t]*#.*\n    |
^[ \t]*\n       { /* Ignora comentários e linhas em branco */ }

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

[_a-zA-Z][_0-9a-zA-Z]* { yylval.stringValue = strdup(yytext); return NAME; }

\"[^\"\n]*\" |
\'[^'\n]*\'    {
                    yylval.stringValue = (char*)malloc(yyleng - 1);
                    strncpy(yylval.stringValue, yytext + 1, yyleng - 2);
                    yylval.stringValue[yyleng - 2] = '\0';
                    return STR; 
                }

[+-]?(0\.[0-9]+|[1-9][0-9]*\.[0-9]+) { yylval.floatValue = atof(yytext); return FLOAT; }
[+-]?(0|[1-9][0-9]*)               { yylval.intValue = atoi(yytext); return INT; }

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

[ \t]+          { /* Ignora espaços no meio da linha */ }

<<EOF>>         {
    while (indent_top > 1) {
        indent_top--;
        push_token(DEDENT);
    }
    int t = pop_token();
    return t ? t : 0;
}

.               { fprintf(stderr, "Caractere inválido na linha %d: %s\n", yylineno, yytext); }

%%

void scanner_init(void) {
    indent_top = 1;
    indent_stack[0] = 0;
    pending_top = 0;
    BEGIN(INDENT_CHECK);
}