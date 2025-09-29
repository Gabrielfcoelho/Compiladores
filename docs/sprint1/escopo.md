# Introdução

Este documento descreve o escopo do projeto, detalhando as funcionalidades e limitações do compilador Python -> Ruby a ser desenvolvido pela equipe. O objetivo principal é criar uma ferramenta que permita a conversão automática de código Python para Ruby, construindo o analisador léxico e analisador sintático.

## Escopo do Projeto

Para definir o escopo do projeto, foram considerados aspectos recomendados pelo professor durante as aulas e o tempo disponível no semestre para implementação. O escopo escolhido inclui:

- **Funcionalidades Principais**:
  - Estruturas de controle if e while.
  - Definição e chamada de funções.
  - Manipulação de variáveis e tipos de dados básicos (inteiros, floats, strings, arrays).
  - Comentários em linha
  - Operações aritméticas: adição, subtração, multiplicação, divisão, potenciação e módulo.
  - Operações de comparação: igual, diferente, maior, menor, maior ou igual e menor ou igual.
  - Identação para definir blocos de código.

## Justificativa do Escopo

Esse conjunto de funcionalidades foi escolhido por estar presente na ementa da matéria de Algoritmos e Programação de computadores, garantindo que o compilador seja capaz de lidar com a maioria dos casos básicos encontrados em programas simples, servindo como uma base sólida para futuras expansões e criação de programas mais complexos.

## Referências bibliográficas

1. PYTHON SOFTWARE FOUNDATION. Python 3 — Documentação oficial. Disponível em: <https://docs.python.org/3/>. Acesso em: 29 set. 2025.
2. UNIVERSIDADE DE BRASÍLIA (UnB). CIC0004 — Algoritmos e Programação de Computadores. SIGAA - Sistema Integrado de Gestão de Atividades Acadêmicas. Disponível em: <https://sigaa.unb.br/sigaa/public/departamento/componentes.jsf>. Acesso em: 29 set. 2025.

## Histórico de Versões

| Versão | Data       | Descrição                                                       | Autor(es)                                                     |
| ------ | ---------- | --------------------------------------------------------------- | ------------------------------------------------------------- |
| `1.0`  | 29/09/2025 | Versão inicial do documento, com a definição inicial do escopo. | [Matheus de Alcântara](https://github.com/matheusdealcantara) |
