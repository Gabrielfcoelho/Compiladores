# Análise Léxica

## Objetivo
Descrever o funcionamento do analisador léxico (lexer) do compilador, incluindo os tokens reconhecidos, suas expressões regulares e exemplos de entradas e saídas.

---

## Tokens Reconhecidos
O lexer reconhece os seguintes tokens:

| Token       | Lexema (ex.) | Regex/Descrição                  | Valor semântico |
|-------------|--------------|----------------------------------|-----------------|
| IDENT       | myVar        | [_a-zA-Z][_0-9a-zA-Z]*          | Nome do identificador |
| INT         | 123          | [+-]?(0|[1-9][0-9]*)            | Valor inteiro   |
| FLOAT       | 3.14         | [+-]?(0\.[0-9]+|[1-9][0-9]*\.[0-9]+) | Valor de ponto flutuante |
| STR         | "texto"      | \".*?\" ou \'*?\'               | Literal string  |
| PLUS        | +            | \+                               | Operador adição |
| MINUS       | -            | \-                               | Operador subtração |
| TIMES       | *            | \*                               | Operador multiplicação |
| DIVIDE      | /            | /                                | Operador divisão |
| LPAREN      | (            | \(                               | Parêntese esquerdo |
| RPAREN      | )            | \)                               | Parêntese direito |
| COLON       | :            | :                                | Dois pontos     |
| COMA        | ,            | ,                                | Vírgula         |
| GT          | >            | >                                | Maior que       |
| LT          | <            | <                                | Menor que       |
| EQ          | ==           | ==                               | Igualdade       |
| NEQ         | !=           | !=                               | Diferente       |

---

## Funcionamento
O analisador léxico utiliza expressões regulares para identificar os tokens no código-fonte. Ele ignora espaços em branco e comentários, e gera erros para caracteres inválidos.

### Exemplo de Entrada e Saída
#### Entrada
```python
def func():
    if 10 > 5:
        return 1
```

#### Saída
```
TOKEN: def, lex: 'def'
TOKEN: LPAREN, lex: '('
TOKEN: RPAREN, lex: ')'
TOKEN: COLON, lex: ':'
TOKEN: NEWLINE
TOKEN: INDENT (empilhado)
TOKEN: if, lex: 'if'
TOKEN: INT, lex: '10'
TOKEN: GT, lex: '>'
TOKEN: INT, lex: '5'
TOKEN: COLON, lex: ':'
TOKEN: NEWLINE
TOKEN: INDENT (empilhado)
TOKEN: return, lex: 'return'
TOKEN: INT, lex: '1'
TOKEN: EOF, lex: ''
TOKEN: DEDENT (empilhado)
TOKEN: DEDENT (empilhado)
TOKEN: NEWLINE (empilhado no EOF)
```

---

## Tratamento de Erros Léxicos
O lexer identifica e reporta erros para caracteres inválidos. Por exemplo:

#### Entrada Inválida
```python
x = 10 @ 5
```

#### Mensagem de Erro
```
Caractere inválido: @
```

---

## Referências
- Código do lexer (`lexer/lexer.l`).
- Documentação do projeto.
