# Análise Sintática

## Objetivo
Descrever o funcionamento do analisador sintático (parser) do compilador, incluindo a gramática utilizada e tratamento de erros sintáticos.

---

## Gramática
O parser utiliza a seguinte gramática para analisar o código-fonte:

### Definição em BNF
```bnf
program      ::= statement_list
statement_list ::= statement | statement_list statement
statement    ::= simple_statement NEWLINE | compound_statement
simple_statement ::= expression | RTRN expression | RTRN | BRK | IDENT
compound_statement ::= if_statement | while_statement | function_definition
if_statement ::= IF expression COLON suite
               | IF expression COLON suite ELSE COLON suite
               | IF expression COLON suite elif_clauses ELSE COLON suite
elif_clauses ::= ELIF expression COLON suite | elif_clauses ELIF expression COLON suite
while_statement ::= WHL expression COLON suite
function_definition ::= DEF IDENT LPAREN RPAREN COLON suite
suite        ::= NEWLINE INDENT statement_list DEDENT
expression   ::= expression PLUS expression
               | expression MINUS expression
               | expression TIMES expression
               | expression DIVIDE expression
               | LPAREN expression RPAREN
               | INT | FLOAT | STR
```

---

## Tratamento de Erros Sintáticos
O parser identifica e reporta erros de sintaxe, como tokens inesperados ou estruturas incompletas. Exemplos:

### Exemplo 1: Token Inesperado
#### Entrada
```python
if x > 0
    y = y + 1
```

#### Mensagem de Erro
```
Erro sintático na linha 2 próximo a 'y': esperado ':'
```

### Exemplo 2: Estrutura Incompleta
#### Entrada
```python
def func(
```

#### Mensagem de Erro
```
Erro sintático na linha 1 próximo a 'EOF': esperado ')'
```

---

## Referências
- Código do parser (`parser/parser.y`).
- Documentação do projeto.
