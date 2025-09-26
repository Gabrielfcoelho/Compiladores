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

/* tag para controlar o eof, estava duplicado*/
static int eof_processed = 0;

void scanner_init(void);

static void push_token(int tok) {
    if (pending_top >= PENDING_MAX) {
        fprintf(stderr, "Erro: Pilha de tokens pendentes cheia.\n");
        exit(1);
    }
    switch(tok) {
        case INDENT: printf("TOKEN: INDENT (empilhado)\n"); break;
        case DEDENT: printf("TOKEN: DEDENT (empilhado)\n"); break;
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
(\r\n|\n|\r)+            { printf("TOKEN: NEWLINE\n"); BEGIN(INDENT_CHECK); return NEWLINE; }

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

"def"           { printf("TOKEN: def, lex: '%s'\n", yytext); return DEF; }
"return"        { printf("TOKEN: return, lex: '%s'\n", yytext); return RTRN; }
"if"            { printf("TOKEN: if, lex: '%s'\n", yytext); return IF; }
"elif"          { printf("TOKEN: elif, lex: '%s'\n", yytext); return ELIF; }
"else"          { printf("TOKEN: else, lex: '%s'\n", yytext); return ELSE; }
"while"         { printf("TOKEN: while, lex: '%s'\n", yytext); return WHL; }
"break"         { printf("TOKEN: break, lex: '%s'\n", yytext); return BRK; }
"False"         { printf("TOKEN: False, lex: '%s'\n", yytext); return FLS; }
"True"          { printf("TOKEN: True, lex: '%s'\n", yytext); return TRUE; }
"None"          { printf("TOKEN: None, lex: '%s'\n", yytext); return NONE; }
"is"            { printf("TOKEN: is, lex: '%s'\n", yytext); return IS; }
"and"           { printf("TOKEN: and, lex: '%s'\n", yytext); return AND; }
"or"            { printf("TOKEN: or, lex: '%s'\n", yytext); return OR; }
"not"           { printf("TOKEN: not, lex: '%s'\n", yytext); return NOT; }

[_a-zA-Z][_0-9a-zA-Z]* { yylval.stringValue = strdup(yytext); return NAME; }

\"[^\"\n]*\" |
\'[^'\n]*\'    {
                    yylval.stringValue = (char*)malloc(yyleng - 1);
                    strncpy(yylval.stringValue, yytext + 1, yyleng - 2);
                    yylval.stringValue[yyleng - 2] = '\0';
                    return STR; 
                }

[+-]?(0\.[0-9]+|[1-9][0-9]*\.[0-9]+) { printf("TOKEN: FLOAT, lex: '%s'\n", yytext); yylval.floatValue = atof(yytext); return FLOAT; }
[+-]?(0|[1-9][0-9]*)               { printf("TOKEN: INT, lex: '%s'\n", yytext); yylval.intValue = atoi(yytext); return INT; }

"+"             { printf("TOKEN: PLUS, lex: '%s'\n", yytext); return PLUS; }
"-"             { printf("TOKEN: MINUS, lex: '%s'\n", yytext); return MINUS; }
"*"             { printf("TOKEN: TIMES, lex: '%s'\n", yytext); return TIMES; }
"/"             { printf("TOKEN: DIVIDE, lex: '%s'\n", yytext); return DIVIDE; }
"("             { printf("TOKEN: LPAREN, lex: '%s'\n", yytext); return LPAREN; }
")"             { printf("TOKEN: RPAREN, lex: '%s'\n", yytext); return RPAREN; }
"{"             { printf("TOKEN: LCBRACKET, lex: '%s'\n", yytext); return LCBRACKET; }
"}"             { printf("TOKEN: RCBRACKET, lex: '%s'\n", yytext); return RCBRACKET; }
"["             { printf("TOKEN: LSBRACKET, lex: '%s'\n", yytext); return LSBRACKET; }
"]"             { printf("TOKEN: RSBRACKET, lex: '%s'\n", yytext); return RSBRACKET; }
":"             { printf("TOKEN: COLON, lex: '%s'\n", yytext); return COLON; }
","             { printf("TOKEN: COMA, lex: '%s'\n", yytext); return COMA; }
">"             { printf("TOKEN: GT, lex: '%s'\n", yytext);  return GT; }
"<"             { printf("TOKEN: LT, lex: '%s'\n", yytext); return LT; }
"=="            { printf("TOKEN: EQ, lex: '%s'\n", yytext); return EQ; }
"!="            { printf("TOKEN: NEQ, lex: '%s'\n", yytext); return NEQ; }
">="            { printf("TOKEN: GE, lex: '%s'\n", yytext); return GE; }
"<="            { printf("TOKEN: LE, lex: '%s'\n", yytext); return LE; }

[ \t]+          { /* Ignora espaços no meio da linha */ }

<<EOF>>         {
    
    if (eof_processed) {
        return 0; // Se já processamos o EOF, apenas retorne 0.
    }
    eof_processed = 1;

    printf("TOKEN: EOF, lex: ''\n");

    while (indent_top > 1) {
        indent_top--;
        push_token(DEDENT);
    }

    push_token(NEWLINE); 
    printf("TOKEN: NEWLINE (empilhado no EOF)\n");

    int t = pop_token();
    return t ? t : 0;
}

.               { fprintf(stderr, "Caractere inválido na linha %d: %s\n", yylineno, yytext); }

%%

void scanner_init(void) {
    indent_top = 1;
    indent_stack[0] = 0;
    pending_top = 0;
    //BEGIN(INDENT_CHECK);
}