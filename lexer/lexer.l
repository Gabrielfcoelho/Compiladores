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
        case INDENT: fprintf(stderr,"TOKEN: INDENT (empilhado)\n"); break;
        case DEDENT: fprintf(stderr,"TOKEN: DEDENT (empilhado)\n"); break;
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
(\r\n|\n|\r)+            { fprintf(stderr,"TOKEN: NEWLINE\n"); BEGIN(INDENT_CHECK); return NEWLINE; }

<INDENT_CHECK>[ \t]*[^ \t\n#] {
    /* Calcula a indentação antes de fazer yyless */
    int current_indent = count_indent(yytext);
    /* Volta um caractere para não consumir o conteúdo da linha */
    yyless(yyleng - 1);
    
    /* CORREÇÃO: Verifica se a pilha tem elementos antes de acessar */
    int previous_indent = (indent_top > 0) ? indent_stack[indent_top - 1] : 0;

    if (current_indent > previous_indent) {
        if (indent_top >= INDENT_MAX) {
            fprintf(stderr, "Erro: Nível máximo de indentação excedido.\n");
            exit(1);
        }
        indent_stack[indent_top++] = current_indent;
        BEGIN(INITIAL);
        fprintf(stderr,"TOKEN: INDENT (empilhado)\n");
        return INDENT;
    } else if (current_indent < previous_indent) {
        while (indent_top > 0 && current_indent < indent_stack[indent_top - 1]) {
            indent_top--;
            push_token(DEDENT);
        }
        if (indent_top > 0 && current_indent != indent_stack[indent_top - 1]) {
            fprintf(stderr, "Erro de Indentação na linha %d: nível inconsistente.\n", yylineno);
            exit(1);
        }
    }
    
    BEGIN(INITIAL);
    int t = pop_token();
    if (t) return t;
}

<INDENT_CHECK>[ \t]*\n {
    /* Linha vazia - ignora e continua no estado INDENT_CHECK */
    BEGIN(INDENT_CHECK);
}

<INDENT_CHECK>[ \t]*# {
    /* Comentário - ignora o resto da linha */
    BEGIN(INITIAL);
    yyless(0);
}

<INDENT_CHECK><<EOF>> {
    return 0;
}

^[ \t]*#.*\n    |
^[ \t]*\n       { /* Ignora comentários e linhas em branco */ }

"def"           { fprintf(stderr,"TOKEN: def, lex: '%s'\n", yytext); return DEF; }
"return"        { fprintf(stderr,"TOKEN: return, lex: '%s'\n", yytext); return RTRN; }
"if"            { fprintf(stderr,"TOKEN: if, lex: '%s'\n", yytext); return IF; }
"elif"          { fprintf(stderr,"TOKEN: elif, lex: '%s'\n", yytext); return ELIF; }
"else"          { fprintf(stderr,"TOKEN: else, lex: '%s'\n", yytext); return ELSE; }
"while"         { fprintf(stderr,"TOKEN: while, lex: '%s'\n", yytext); return WHL; }
"break"         { fprintf(stderr,"TOKEN: break, lex: '%s'\n", yytext); return BRK; }
"False"         { fprintf(stderr,"TOKEN: False, lex: '%s'\n", yytext); return FLS; }
"True"          { fprintf(stderr,"TOKEN: True, lex: '%s'\n", yytext); return TRUE; }
"None"          { fprintf(stderr,"TOKEN: None, lex: '%s'\n", yytext); return NONE; }
"is"            { fprintf(stderr,"TOKEN: is, lex: '%s'\n", yytext); return IS; }
"and"           { fprintf(stderr,"TOKEN: and, lex: '%s'\n", yytext); return AND; }
"or"            { fprintf(stderr,"TOKEN: or, lex: '%s'\n", yytext); return OR; }
"not"           { fprintf(stderr,"TOKEN: not, lex: '%s'\n", yytext); return NOT; }

[_a-zA-Z][_0-9a-zA-Z]* { yylval.stringValue = strdup(yytext); return NAME; }

\"[^\"\n]*\" |
\'[^'\n]*\'    {
                    yylval.stringValue = (char*)malloc(yyleng - 1);
                    strncpy(yylval.stringValue, yytext + 1, yyleng - 2);
                    yylval.stringValue[yyleng - 2] = '\0';
                    return STR; 
                }

[+-]?(0\.[0-9]+|[1-9][0-9]*\.[0-9]+) { fprintf(stderr,"TOKEN: FLOAT, lex: '%s'\n", yytext); yylval.floatValue = atof(yytext); return FLOAT; }
[+-]?(0|[1-9][0-9]*)               { fprintf(stderr,"TOKEN: INT, lex: '%s'\n", yytext); yylval.intValue = atoi(yytext); return INT; }

"+"             { fprintf(stderr,"TOKEN: PLUS, lex: '%s'\n", yytext); return PLUS; }
"-"             { fprintf(stderr,"TOKEN: MINUS, lex: '%s'\n", yytext); return MINUS; }
"*"             { fprintf(stderr,"TOKEN: TIMES, lex: '%s'\n", yytext); return TIMES; }
"/"             { fprintf(stderr,"TOKEN: DIVIDE, lex: '%s'\n", yytext); return DIVIDE; }
"("             { fprintf(stderr,"TOKEN: LPAREN, lex: '%s'\n", yytext); return LPAREN; }
")"             { fprintf(stderr,"TOKEN: RPAREN, lex: '%s'\n", yytext); return RPAREN; }
"{"             { fprintf(stderr,"TOKEN: LCBRACKET, lex: '%s'\n", yytext); return LCBRACKET; }
"}"             { fprintf(stderr,"TOKEN: RCBRACKET, lex: '%s'\n", yytext); return RCBRACKET; }
"["             { fprintf(stderr,"TOKEN: LSBRACKET, lex: '%s'\n", yytext); return LSBRACKET; }
"]"             { fprintf(stderr,"TOKEN: RSBRACKET, lex: '%s'\n", yytext); return RSBRACKET; }
":"             { fprintf(stderr,"TOKEN: COLON, lex: '%s'\n", yytext); return COLON; }
","             { fprintf(stderr,"TOKEN: COMA, lex: '%s'\n", yytext); return COMA; }
">"             { fprintf(stderr,"TOKEN: GT, lex: '%s'\n", yytext);  return GT; }
"<"             { fprintf(stderr,"TOKEN: LT, lex: '%s'\n", yytext); return LT; }
"=="            { fprintf(stderr,"TOKEN: EQ, lex: '%s'\n", yytext); return EQ; }
"!="            { fprintf(stderr,"TOKEN: NEQ, lex: '%s'\n", yytext); return NEQ; }
">="            { fprintf(stderr,"TOKEN: GE, lex: '%s'\n", yytext); return GE; }
"<="            { fprintf(stderr,"TOKEN: LE, lex: '%s'\n", yytext); return LE; }
"="             { fprintf(stderr,"TOKEN: ASSIGN, lex: '%s'\n", yytext); return ASSIGN; }


[ \t]+          { /* Ignora espaços no meio da linha */ }

<<EOF>>         {
    
    if (eof_processed) {
        return 0; // Se já processamos o EOF, apenas retorne 0.
    }
    eof_processed = 1;

    fprintf(stderr,"TOKEN: EOF, lex: ''\n");

    while (indent_top > 1) {
        indent_top--;
        push_token(DEDENT);
    }

    push_token(NEWLINE); 
    fprintf(stderr,"TOKEN: NEWLINE (empilhado no EOF)\n");

    int t = pop_token();
    return t ? t : 0;
}

.               { fprintf(stderr, "Caractere inválido na linha %d: %s\n", yylineno, yytext); }

%%

void scanner_init(void) {
    indent_top = 1;
    indent_stack[0] = 0;
    pending_top = 0;
    eof_processed = 0;
    BEGIN(INITIAL);
}