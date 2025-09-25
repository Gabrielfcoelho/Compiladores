%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* pilha de tokens pendentes (emitidos pelo tratamento de indentação) */
#define PENDING_MAX 128
static int pending[PENDING_MAX];
static int pending_top = 0;

/* pilha de níveis de indentação (em número de espaços); */
/* índice 0 = 0 */
#define INDENT_MAX 256
static int indent_stack[INDENT_MAX];
static int indent_top = 0;

/* flag indicando que estamos no início lógico de linha (após uma quebra) */
static int inicio_linha = 1;

/* helpers para pilha */
static void empilha_token(int tok) {
    if (pending_top >= PENDING_MAX) {
        fprintf(stderr, "Erro: pilha de tokens pendentes cheia\n");
        exit(1);
    }
    pending[pending_top++] = tok;
}

static int desempilha_token(void) {
    if (pending_top == 0) return 0;
    return pending[--pending_top];
}

/* converte indent string (espaços/tabs) para número de espaços (tabsize = 8) */
static int conta_indent(const char *s) {
    int n = 0;
    for (; *s; ++s) {
        if (*s == ' ') n += 1;
        else if (*s == '\t') n += 8 - (n % 8);
        else break;
    }
    return n;
}

static void inicializa_indent(void) {
    indent_top = 1;
    indent_stack[0] = 0;
    pending_top = 0;
}

#undef YY_DECL
#define YY_DECL int scanner_principal(void)
%}

%option yylineno
%option noyywrap

%%

^[ \t]+(\r\n|\r|\n)+ {
                        /* Esta regra captura linhas que contêm APENAS espaços/tabs */
                        /* e as ignora, tratando-as como uma linha em branco. */
                        inicio_linha = 1;
                    }

(\r\n|\r|\n)+   {
                    inicio_linha = 1;
                    /* Atualiza o contador de linha yylineno */
                }

^[ \t]*              {
                        if (!inicio_linha) { /* espaços no meio da linha são ignorados */
                            BEGIN(INITIAL);
                            continue;
                        }
                        /* Calcula o INDENT atual */
                        int ind = conta_indent(yytext);
                        int prev = indent_stack[indent_top-1];

                        if (ind > prev) { /* aumento de indent: empilha novo nível e emite INDENTACAO */
                            indent_stack[indent_top++] = ind;
                            empilha_token(INDENT);
                            empilha_token(NEWLINE);
                        }
                        else if (ind < prev) { /* redução: emitir N * DESINDENT + NOVA_LINHA */
                            while (ind < indent_stack[indent_top-1]) {
                                if (indent_top <= 1) {
                                    fprintf(stderr, "Erro: desindentação inválida na linha %d\n", yylineno);
                                    exit(1);
                                }
                                indent_top--;
                                empilha_token(DEDENT);
                            }
                            empilha_token(NEWLINE); /* Empilha por último, para sair primeiro */
                            
                            /* se o nível não coincide, é erro de indentação real em Python; */
                            /* aqui apenas avisa */
                            if (indent_stack[indent_top-1] != ind) {
                                fprintf(stderr, "Aviso: nível de indentação inconsistente na linha %d\n", yylineno);
                                exit(1);
                            }
                        }
                        else {
                            /* mesma indentação: emitir NOVA_LINHA apenas */
                            empilha_token(NEWLINE);
                        }
                        inicio_linha = 0;
                        /* devolver o token pendente mais recente (fila LIFO) */
                        int t = desempilha_token();
                        if (t) return t;
                    }

^[ \t]*\#[^\r\n]* {
                        /* permanece inicio_linha = 1 para que próximas quebras/linhas vazias sejam ignoradas */
                        /* consumir comentário e não retornar nada */
                        inicio_linha = 1;
                    }

"def"           { inicio_linha = 0; return DEF; }
"return"        { inicio_linha = 0; return RTRN; }
"if"            { inicio_linha = 0; return IF; }
"elif"          { inicio_linha = 0; return ELIF; }
"else"          { inicio_linha = 0; return ELSE; }
"while"         { inicio_linha = 0; return WHL; }
"break"         { inicio_linha = 0; return BRK; }
"False"         { inicio_linha = 0; return FLS; }
"True"          { inicio_linha = 0; return TRUE; }
"None"          { inicio_linha = 0; return NONE; }
"is"            { inicio_linha = 0; return IS; }
"and"           { inicio_linha = 0; return AND; }
"or"            { inicio_linha = 0; return OR; }
"not"           { inicio_linha = 0; return NOT; }

[_a-zA-Z][_0-9a-zA-Z]* { inicio_linha = 0; return NAME; }

(\".*?\")|(\'.*?\')                       {   
                                            size_t len = strlen(yytext);
                                            char *str = (char*)malloc(len - 1);
                                            strncpy(str, yytext + 1, len - 2);
                                            str[len - 2] = '\0';
                                            yylval.stringValue = str;
                                            inicio_linha = 0;
                                            return STR; 
                                        }
[+-]?(0\.[0-9]*|[1-9][0-9]*\.[0-9]*)    { yylval.floatValue = atof(yytext); inicio_linha = 0; return FLOAT; }
[+-]?(0+|[1-9][0-9]*)                   { yylval.intValue = atoi(yytext); inicio_linha = 0; return INT; }

"+"             { inicio_linha = 0; return PLUS; }
"-"             { inicio_linha = 0; return MINUS; }
"*"             { inicio_linha = 0; return TIMES; }
"/"             { inicio_linha = 0; return DIVIDE; }

"("             { inicio_linha = 0; return LPAREN; }
")"             { inicio_linha = 0; return RPAREN; }
"{"             { inicio_linha = 0; return LCBRACKET; }
"}"             { inicio_linha = 0; return RCBRACKET; }
"["             { inicio_linha = 0; return LSBRACKET; }
"]"             { inicio_linha = 0; return RSBRACKET; }
":"             { inicio_linha = 0; return COLON; }
","             { inicio_linha = 0; return COMA; }

[ \t]+          { /* consumir espaços no meio da linha */ }

<<EOF>>         {
                    /* se tiver INDENT abertas, fechar com DEDENT */
                    if (indent_top > 1) {
                        while (indent_top > 1) {
                            indent_top--;
                            empilha_token(DEDENT);
                        }
                        empilha_token(NEWLINE); 
                    }
                    /* se houver tokens pendentes, retornar um por vez através do wrapper yylex */
                    inicio_linha = 0;
                    return 0;
                }

.               { printf("Caractere inválido: %s\n", yytext); }

%%

int yylex(void) {
    int t = desempilha_token();
    if (t) return t;
    return scanner_principal();
}

__attribute__((constructor))
static void inicializa_indent_construtor(void) {
    inicializa_indent();
}
