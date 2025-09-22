%{
#include "parser2.tab.h"
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

(\r\n|\r|\n)+   {
                    inicio_linha = 1;
                    /* Atualiza o contador de linha yylineno */
                }

^[ \t]+              {
                        if (!inicio_linha) { /* espaços no meio da linha são ignorados */
                            BEGIN(INITIAL);
                            continue;
                        }
                        /* Calcula o INDENT atual */
                        int ind = conta_indent(yytext);
                        int prev = indent_stack[indent_top-1];

                        if (ind > prev) { /* aumento de indent: empilha novo nível e emite INDENTACAO */
                            indent_stack[indent_top++] = ind;
                            empilha_token(NEWLINE); /* antes do INDENTACAO emitir NEWLINE (fim lógico da linha anterior) */
                            empilha_token(INDENT);
                        }
                        else if (ind < prev) { /* redução: emitir NOVA_LINHA + N * DESINDENT */
                            empilha_token(NEWLINE);
                            while (ind < indent_stack[indent_top-1]) {
                                if (indent_top <= 1) {
                                    fprintf(stderr, "Erro: desindentação inválida na linha %d\n", yylineno);
                                    exit(1);
                                }
                                indent_top--;
                                empilha_token(DEDENT);
                            }
                            /* se o nível não coincide, é erro de indentação real em Python; */
                            /* aqui apenas avisa */
                            if (indent_stack[indent_top-1] != ind) {
                                fprintf(stderr, "Aviso: nível de indentação inconsistente na linha %d\n", yylineno);
                                exit(1);
                            }
                        } else {
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

[0-9]+          { yylval.ival = atoi(yytext); inicio_linha= 0; return NUM; }
"+"             { inicio_linha=0; return PLUS; }
"-"             { inicio_linha=0; return MINUS; }
"*"             { inicio_linha=0; return TIMES; }
"/"             { inicio_linha=0; return DIVIDE; }
"("             { inicio_linha=0; return LPAREN; }
")"             { inicio_linha=0; return RPAREN; }

[ \t]+          { /* consumir espaços no meio da linha */ }

<<EOF>>         {
                    /* so tiver INDENT abertas, fechar com DEDENT */
                    if (indent_top > 1) {
                        empilha_token(NEWLINE);
                        while (indent_top > 1) {
                            indent_top--;
                            empilha_token(DEDENT);
                        }
                    }
                    /* se houver tokens pendentes, retornar um por vez através do wrapper yylex */
                    inicio_linha = 0;
                    return 0;
                }

%%

/* wrapper: devolve tokens pendentes antes de chamar o scanner gerado (sclex) */
int sclex(void); /* protótipo da função gerada por flex com prefix "sc" */

int yylex(void) {
    int t = desempilha_token();
    if (t) return t;
    return scanner_principal();
}

/* bloco final: inicializa a pilha em runtime */
__attribute__((constructor))
static void inicializa_indent_construtor(void) {
    inicializa_indent();
}