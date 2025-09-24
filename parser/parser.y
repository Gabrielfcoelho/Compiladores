%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno; // Para reportar o número da linha no erro
extern char *yytext; // Para reportar o texto do token no erro
%}

/* SEÇÃO 1: DECLARAÇÕES DE VALORES SEMÂNTICOS (UNION) */
%union {
    int ival;
    int intValue;
    float floatValue;
    char *stringValue;
}

/* SEÇÃO 2: DECLARAÇÃO DE TOKENS */
// Tokens de Palavras-Chave
%token DEF RTRN IF ELIF ELSE WHL BRK FLS TRUE NONE IS AND OR NOT 

// Tokens de Expressões e Literais
%token <ival> NUM
%token <intValue> INT
%token <floatValue> FLOAT
%token <stringValue> STR
%token NAME
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

// Tokens de Delimitadores
%token RCBRACKET LCBRACKET RSBRACKET LSBRACKET COLON COMA

// Tokens de Estrutura e Indentação
%token INDENT DEDENT NEWLINE

/* SEÇÃO 3: DECLARAÇÃO DE PRECEDÊNCIA */
%type <ival> expressao

%left PLUS MINUS
%left TIMES DIVIDE

// A regra inicial da gramática
%start programa

%%

/* SEÇÃO 4: REGRAS DA GRAMÁTICA */

// A regra 'programa' é o ponto de entrada. Um programa é uma sequência de declarações.
programa:
    /* um programa pode começar vazio */
  | programa declaracao
  | programa identificadores
  ;

// 'declaracao' pode ser uma declaração simples ou composta.
declaracao:
    declaracao_simples NEWLINE
  | declaracao_composta 
  ;

// Declarações compostas são aquelas que contêm outras declarações (ex: if, while).
declaracao_composta:
    decl_if
  | decl_while
  | funcao
  | decl_else
  | decl_elif
  ;

// Declarações simples são aquelas que não contêm outras (ex: return, break).
declaracao_simples:
    expressao
  | decl_rtrn
  | decl_brk
  | decl_and
  | decl_or
  | decl_not
  | decl_fls
  | decl_true
  | decl_none
  ;

// Identificadores
identificadores:
    NAME { printf("Nome válido\n"); }
  | expressao
  ;

// REGRA CHAVE: Define o que é um bloco de código indentado.
bloco:
    NEWLINE INDENT declaracoes DEDENT
  ;

// Um bloco contém uma ou mais declarações.
declaracoes:
    declaracao
  | declaracoes declaracao
  ;

// Regras para declarações específicas (palavras-chave)
decl_if: 
    IF expressao COLON bloco { printf(">> Gramática: Reconheci um IF com bloco.\n"); }
  | IF { printf("recebi um if\n"); }

decl_while: 
    WHL expressao COLON bloco { printf(">> Gramática: Reconheci um WHILE com bloco.\n"); }
  | WHL { printf("recebi um while\n"); }

funcao: 
    DEF COLON bloco { printf(">> Gramática: Reconheci uma função DEF com bloco.\n"); }
  | DEF { printf("recebi um def\n"); }

decl_else: ELSE { printf("recebi um else\n"); }
decl_elif: ELIF { printf("recebi um elif\n"); }

decl_rtrn: 
    RTRN expressao { printf(">> Gramática: Reconheci um RETURN.\n"); }
  | RTRN { printf("recebi um return\n"); }

decl_brk: 
    BRK { printf(">> Gramática: Reconheci um BREAK.\n"); }

decl_and: AND { printf("recebi um and\n"); }
decl_or: OR { printf("recebi um or\n"); }
decl_not: NOT { printf("recebi um not\n"); }
decl_fls: FLS { printf("recebi um False\n"); }
decl_true: TRUE { printf("recebi um True\n"); }
decl_none: NONE { printf("recebi um None\n"); }

// Regra para expressões (unificada de todos os parsers)
expressao:
    expressao PLUS expressao    { $$ = $1 + $3; }
  | expressao MINUS expressao   { $$ = $1 - $3; }
  | expressao TIMES expressao   { $$ = $1 * $3; }
  | expressao DIVIDE expressao  {
        if ($3 == 0) {
            fprintf(stderr, "Erro: divisão por zero na linha %d\n", yylineno);
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
  | LPAREN expressao RPAREN     { $$ = $2; }
  | LCBRACKET expressao RCBRACKET
  | LSBRACKET expressao RSBRACKET
  | COMA expressao
  | COLON
  | expressao STR               { printf("String lida: %s\n", $2); } 
  | expressao FLOAT             { printf("FLOAT lido: %f\n", $2); }
  | expressao INT               { printf("Inteiro lido: %d\n", $2); }
  | STR                         { printf("String lida: %s\n", $1); } 
  | FLOAT                       { printf("FLOAT lido: %f\n", $1); }
  | INT                         { printf("Inteiro lido: %d\n", $1); }
  | NUM                         { $$ = $1; printf("Numero lido\n"); }
  ;

%%

/*
 * SEÇÃO 5: CÓDIGO AUXILIAR C
 */

// Função chamada pelo Bison quando um erro de sintaxe é encontrado.
void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha %d próximo a '%s': %s\n",
            yylineno, yytext ? yytext : "EOF", s);
}

// Função principal que inicia a análise.
int main(void) {
    // yyparse() chama yylex() para obter os tokens e aplicar as regras da gramática.
    return yyparse();
}
