%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void scanner_init(void);

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
extern char *yytext;
%}

%union {
    int intValue;
    float floatValue;
    char *stringValue;
}

/* DECLARAÇÃO DE TOKENS */
%token DEF RTRN IF ELIF ELSE WHL BRK FLS TRUE NONE AND OR NOT
%token <intValue> INT
%token <floatValue> FLOAT
%token <stringValue> STR NAME
%token PLUS MINUS TIMES DIVIDE LPAREN RPAREN
%token RCBRACKET LCBRACKET RSBRACKET LSBRACKET COLON COMA
%token GT LT EQ NEQ GE LE IS
%token ASSIGN
%token INDENT DEDENT NEWLINE

/* PRECEDÊNCIA E ASSOCIAÇÃO DE OPERADORES */
%left OR
%left AND
%left NOT
%left IS
%left EQ NEQ
%left GT LT GE LE
%left PLUS MINUS
%left TIMES DIVIDE

/* TIPOS PARA NÃO-TERMINAIS QUE RETORNAM VALORES */
%type <intValue> expression

%start program

%%

/* REGRAS DA GRAMÁTICA */

program:
    /* Um programa pode ser vazio ou uma lista de statements */
    | statement_list
    ;

statement_list:
    statement
    | statement_list statement
    ;

statement:
    simple_statement NEWLINE
    | compound_statement
    ;

/* Statements que não quebram o fluxo normal (terminam com NEWLINE) */
simple_statement:
    expression                      { printf(">> Gramática: Avaliou uma expressão.\n"); }
    | NAME ASSIGN expression        { printf(">> Gramática: Atribuição à variável '%s'.\n", $1); free($1); } 
    | RTRN expression               { printf(">> Gramática: Reconheci um RETURN com expressão.\n"); }
    | RTRN                          { printf(">> Gramática: Reconheci um RETURN vazio.\n"); }
    | BRK                           { printf(">> Gramática: Reconheci um BREAK.\n"); }
    ;

/* Statements que contêm seus próprios blocos (if, while, def) */
compound_statement:
    if_statement
    | while_statement
    | function_definition
    ;

/* Bloco de código indentado */
suite:
    NEWLINE INDENT statement_list DEDENT  { printf(">> Gramática: Suite processada.\n"); }
    | simple_statement NEWLINE             { printf(">> Gramática: Suite simples.\n"); }
    ;

/* Estrutura IF-ELIF-ELSE para remover a ambiguidade "dangling else" */
if_statement:
    IF expression COLON suite                                   { printf(">> Gramática: Bloco IF.\n"); }
    | IF expression COLON suite ELSE COLON suite                { printf(">> Gramática: Bloco IF-ELSE.\n"); }
    | IF expression COLON suite elif_clauses                    { printf(">> Gramática: Bloco IF com ELIFs.\n"); }
    | IF expression COLON suite elif_clauses ELSE COLON suite   { printf(">> Gramática: Bloco IF com ELIFs e ELSE.\n"); }
    ;

elif_clauses:
    ELIF expression COLON suite
    | elif_clauses ELIF expression COLON suite
    ;

while_statement:
    WHL expression COLON suite { printf(">> Gramática: Bloco WHILE.\n"); }
    ;

function_definition:
    DEF NAME LPAREN parameters RPAREN COLON suite { 
        printf(">> Gramática: Definição de função '%s' com parâmetros.\n", $2); 
        free($2); 
    }
    ;

parameters:
    /* vazio */
    | parameter_list
    ;

parameter_list:
    expression                          { printf("   -> Param: %d\n", $1); }
    | parameter_list COMA expression    { printf("   -> Param: %d\n", $3); }
    ;

/* Regras para expressões aritméticas e literais */
expression:
    expression PLUS expression      { $$ = $1 + $3; }
    | expression MINUS expression     { $$ = $1 - $3; }
    | expression TIMES expression     { $$ = $1 * $3; }
    | expression DIVIDE expression    { if($3 != 0) $$ = $1 / $3; else { yyerror("Divisão por zero"); YYERROR; } }
        /* REGRAS DE COMPARAÇÃO ADICIONADAS */
    | expression GT expression        { $$ = $1 > $3; }
    | expression LT expression        { $$ = $1 < $3; }
    | expression EQ expression        { $$ = $1 == $3; }
    | expression NEQ expression       { $$ = $1 != $3; }
    | expression GE expression        { $$ = $1 >= $3; }
    | expression LE expression        { $$ = $1 <= $3; }
    | expression IS expression        { $$ = ($1 == $3); }
    | LPAREN expression RPAREN        { $$ = $2; }
    | INT                             { $$ = $1; }
    | FLOAT                           {/* Ação pendente: union precisa de um campo para float */}
    | STR                             {/* Ação pendente: union precisa de um campo para string */}
    | TRUE                            { $$ = 1; }
    | FLS                             { $$ = 0; }
    | NONE                            { $$ = 0; }
    | NAME                            { printf(">> Gramática: Uso de variável '%s'.\n", $1); free($1); }
    | NAME LPAREN parameter_list RPAREN { printf(">> Gramática: Chamada de função '%s' com argumentos.\n", $1); free($1); }
    ;

%%

/* CÓDIGO AUXILIAR */
void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha %d próximo a '%s': %s\n", yylineno, yytext, s);
}

int main(void) {
    /* Inicializa o scanner (importante para a lógica de indentação) */
    scanner_init(); 
    return yyparse();
}