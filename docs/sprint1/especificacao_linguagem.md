# Especificação da Linguagem — Mini Python

## Objetivo

Esta especificação descreve a linguagem de entrada aceita pelo compilador desenvolvido, incluindo tokens reconhecidos, estruturas sintáticas suportadas e exemplos práticos.

---

## Tokens Reconhecidos

| Token         | Descrição                        | Exemplo         |
|---------------|----------------------------------|-----------------|
| `DEF`         | Definição de função              | `def`           |
| `RTRN`        | Retorno de função                | `return`        |
| `IF`          | Condicional                      | `if`            |
| `ELIF`        | Condicional intermediário        | `elif`          |
| `ELSE`        | Condicional alternativo          | `else`          |
| `WHL`         | Laço de repetição                | `while`         |
| `BRK`         | Interrupção de laço              | `break`         |
| `FLS`         | Booleano falso                   | `False`         |
| `TRUE`        | Booleano verdadeiro              | `True`          |
| `NONE`        | Valor nulo                       | `None`          |
| `AND`, `OR`, `NOT` | Operadores lógicos         | `and`, `or`, `not` |
| `INT`         | Número inteiro                   | `42`            |
| `FLOAT`       | Número de ponto flutuante        | `3.14`          |
| `STR`         | Cadeia de caracteres             | `"texto"`       |
| `NAME`        | Identificador (variável/função)  | `x`, `soma`     |
| `PLUS`        | Soma                             | `+`             |
| `MINUS`       | Subtração                        | `-`             |
| `TIMES`       | Multiplicação                    | `*`             |
| `DIVIDE`      | Divisão                         | `/`             |
| `ASSIGN`      | Atribuição                       | `=`             |
| `EQ`          | Igualdade                        | `==`            |
| `NEQ`         | Diferente                        | `!=`            |
| `GT`          | Maior                            | `>`             |
| `LT`          | Menor                            | `<`             |
| `GE`          | Maior ou igual                   | `>=`            |
| `LE`          | Menor ou igual                   | `<=`            |
| `IS`          | Comparação de identidade         | `is`            |
| `LPAREN`      | Parêntese esquerdo               | `(`             |
| `RPAREN`      | Parêntese direito                | `)`             |
| `RCBRACKET`   | Chave direita                    | `}`             |
| `LCBRACKET`   | Chave esquerda                   | `{`             |
| `RSBRACKET`   | Colchete direito                 | `]`             |
| `LSBRACKET`   | Colchete esquerdo                | `[`             |
| `COLON`       | Dois pontos                      | `:`             |
| `COMA`        | Vírgula                          | `,`             |
| `NEWLINE`     | Nova linha                       |                 |
| `INDENT`      | Indentação (início de bloco)     |                 |
| `DEDENT`      | Fim de bloco                     |                 |

---

## Estruturas Sintáticas Suportadas

### 1. **Atribuição**
```python
x = 10
nome = "Gabriel"

```

### 2. **Expressões Aritméticas e Literais**
```python
resultado = (a + b) * 2 - 5 / 3
valor = 3.14
texto = "Olá"

```

### 3. **Expressões de Comparação**
```python
if x >= 10:
    print("Maior ou igual a 10")

```

### 4. **Estruturas de Controle** 

**if/elif/else**
```python
if x > 0:
    print("Positivo")
elif x == 0:
    print("Zero")
else:
    print("Negativo")

```

**While**
```python
while x > 0:
    x = x - 1

```

### 5. **Definição e Chamada de Funções**
```python
def soma(a, b):
    return a + b

resultado = soma(2, 3)

```

### 6. **Comentário**
```python
# Isto é um comentário

```

### Exemplo Completo
```python
# calcula fatorial
def fatorial(n):
    resultado = 1
    while n > 1:
        resultado = resultado * n
        n = n - 1
    return resultado

x = 5
print(fatorial(x))
```
---

## Conclusão

Esta especificação apresenta um subconjunto da linguagem Python, adaptado para fins didáticos e para o desenvolvimento de um compilador simples. O Compiladorn cobre as principais estruturas de controle, operações aritméticas, funções, variáveis e regras de indentação, permitindo a construção de programas estruturados e legíveis. Apesar das limitações em relação à linguagem Python completa, este subconjunto é suficiente para exercitar conceitos fundamentais de análise léxica, sintática e semântica, servindo como base sólida para estudos e experimentos em compiladores.

## Referências
- PYTHON SOFTWARE FOUNDATION. Python 3 — Documentação oficial. Disponível em: <https://docs.python.org/3/>. Acesso em: 29 set. 2025.

## Histórico de Versões

| Versão | Data       | Descrição                                                       | Autor(es)                                                     |
| ------ | ---------- | --------------------------------------------------------------- | ------------------------------------------------------------- |
| `1.0`  | 30/09/2025 | Especificação da linguagem Python | [Gabriel Flores](https://github.com/Gabrielfcoelho) |
