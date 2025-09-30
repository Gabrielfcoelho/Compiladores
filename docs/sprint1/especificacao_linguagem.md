# Especificação da Linguagem

## Objetivo
Descrever a linguagem de entrada aceita pelo compilador, incluindo sua sintaxe, semântica e exemplos práticos.

---

## Funcionalidades Suportadas
O compilador suporta as seguintes funcionalidades principais:

- **Estruturas de Controle**:
  - `if`, `elif`, `else`.
  - `while`.
- **Definição e Chamada de Funções**:
  - Definição de funções com `def`.
  - Retorno de valores com `return`.
- **Manipulação de Variáveis e Tipos de Dados**:
  - Inteiros, floats e strings.
  - Identação para definir blocos de código.
- **Operações Aritméticas**:
  - Adição (`+`), subtração (`-`), multiplicação (`*`), divisão (`/`).
- **Operações de Comparação**:
  - Igual (`==`), diferente (`!=`), maior (`>`), menor (`<`), maior ou igual (`>=`), menor ou igual (`<=`).
- **Comentários**:
  - Suporte a comentários em linha.

---

## Limitações
Nesta versão inicial, o compilador possui as seguintes limitações:

- Não suporta estruturas de dados complexas como listas ou dicionários.
- Não há suporte para módulos ou bibliotecas externas.
- Não implementa tratamento de exceções.
- Não suporta funções anônimas (lambdas).

Essas limitações foram definidas para manter o escopo do projeto gerenciável dentro do prazo do semestre.

---

## Justificativa do Escopo
O conjunto de funcionalidades foi escolhido com base na ementa da disciplina de Algoritmos e Programação de Computadores, garantindo que o compilador seja capaz de lidar com casos básicos encontrados em programas simples. Isso fornece uma base sólida para futuras expansões e criação de programas mais complexos.

---

## Referências
- PYTHON SOFTWARE FOUNDATION. Python 3 — Documentação oficial. Disponível em: <https://docs.python.org/3/>. Acesso em: 29 set. 2025.
- UNIVERSIDADE DE BRASÍLIA (UnB). CIC0004 — Algoritmos e Programação de Computadores. SIGAA - Sistema Integrado de Gestão de Atividades Acadêmicas. Disponível em: <https://sigaa.unb.br/sigaa/public/departamento/componentes.jsf>. Acesso em: 29 set. 2025.