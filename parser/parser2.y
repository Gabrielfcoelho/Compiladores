%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno; // Para reportar o número da linha no erro
extern char *yytext; // Para reportar o texto do token no erro
%}

/* * SEÇÃO 1: DECLARAÇÕES DE VALORES SEMÂNTICOS (UNION)
 * Define os tipos de dados que os tokens e regras podem armazenar.
 * Por enquanto, usamos apenas 'ival' para números inteiros.
 */
%union {
    int ival;
}

/* * SEÇÃO 2: DECLARAÇÃO DE TOKENS
 * Lista todos os tokens que o lexer pode retornar.
 * Tokens de indentação e palavras-chave são adicionados aqui.
 */
// Tokens de Palavras-Chave
%token DEF RTRN IF ELIF ELSE WHL BRK FLS TRUE NONE IS AND OR NOT 

// Tokens de Expressões
%token <ival> NUM
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN

// Tokens de Estrutura e Indentação
%token INDENT DEDENT NEWLINE COLON


/* * SEÇÃO 3: DECLARAÇÃO DE TIPOS E PRECEDÊNCIA
 * Define o tipo de valor que uma regra gramatical (não-terminal) retorna.
 * Define a precedência e associatividade dos operadores para resolver ambiguidades.
 */
%type <ival> expressao

%left PLUS MINUS
%left TIMES DIVIDE

// A regra inicial da gramática
%start programa

%%

/* * SEÇÃO 4: REGRAS DA GRAMÁTICA
 * Define a sintaxe da sua linguagem.
 */

// A regra 'programa' é o ponto de entrada. Um programa é uma sequência de declarações.
programa:
    /* um programa pode começar vazio */
  | programa declaracao NEWLINE
  ;

// 'declaracao' pode ser uma declaração simples ou composta.
declaracao:
    declaracao_simples
  | declaracao_composta
  ;

// Declarações compostas são aquelas que contêm outras declarações (ex: if, while).
declaracao_composta:
    decl_if
  | decl_while
  | funcao
  ;

// Declarações simples são aquelas que não contêm outras (ex: return, break).
declaracao_simples:
    expressao
  | decl_rtrn
  | decl_brk
  ;

// REGRA CHAVE: Define o que é um bloco de código indentado.
bloco:
    NEWLINE INDENT declaracoes DEDENT
  ;

// Um bloco contém uma ou mais declarações.
declaracoes:
    declaracao NEWLINE
  | declaracoes declaracao NEWLINE
  ;

// Regras para declarações específicas
decl_if: 
    IF expressao COLON bloco { printf(">> Gramática: Reconheci um IF com bloco.\n"); }

decl_while: 
    WHL expressao COLON bloco { printf(">> Gramática: Reconheci um WHILE com bloco.\n"); }

funcao: 
    DEF /* TODO: nome_funcao LPAREN params RPAREN */ COLON bloco { printf(">> Gramática: Reconheci uma função DEF com bloco.\n"); }

decl_rtrn: 
    RTRN expressao { printf(">> Gramática: Reconheci um RETURN.\n"); }

decl_brk: 
    BRK { printf(">> Gramática: Reconheci um BREAK.\n"); }

// Regra para expressões aritméticas (unificada de parser_error.y).
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
  | NUM                         { $$ = $1; }
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