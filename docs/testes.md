# Testes Automatizados do Compilador

## Introdução

Para garantir a qualidade, a estabilidade e a corretude do compilador a cada nova alteração, foi implementado um sistema de testes automatizados. Este documento detalha seu funcionamento, desde a integração contínua com GitHub Actions até a estrutura dos testes locais com Pytest.

> Observação: Ainda há muito a ser melhorado na quantidade e qualidade dos testes. Devido a falhas encontradas durante sua execução, o tempo gasto para corrigi-las impactou tanto o desenvolvimento do projeto quanto a criação de mais testes.

## Automação com GitHub Actions

O pilar da automação é o workflow de Integração Contínua (CI) definido em `.github/workflows/python-tests.yml`. O processo é disparado automaticamente a cada `push` ou `pull request` nos branches `main` e `dev`, garantindo que nenhuma alteração que quebre o projeto seja integrada.

O workflow executa os seguintes passos:
1.  **Configuração do Ambiente:** Prepara uma máquina virtual Linux.
2.  **Instalação de Dependências:** Instala todas as ferramentas necessárias para compilar e testar o projeto:

    - Python 3.x e a biblioteca `pytest`
    - As ferramentas de compilação `flex`, `bison` e a biblioteca `libfl-dev`

3.  **Execução dos Testes:** Roda o conjunto de testes com o comando `pytest .`.
<br>

Qualquer falha, seja na compilação do código C ou na execução dos testes, é imediatamente reportada no GitHub, bloqueando o merge de código defeituoso.

## Estrutura dos Testes com Pytest

Os testes foram escritos em Python utilizando o framework `pytest` e estão localizados em `tests/test_compilador.py`. A lógica foi desenhada para ser simples e expansível.

### 1. Compilação em Tempo Real

Para garantir que estamos sempre testando a versão mais recente do código, o compilador é inicializado toda vez que tem um novo teste.

- **Comando Executado:**

  ```bash
  flex lexer/lexer.l && bison -d parser/parser.y && gcc -o compilador lex.yy.c parser.tab.c -lfl
  ```

  - **Lógica:** Esta `fixture` compila o projeto do zero. Se a compilação falhar por qualquer motivo (erros de sintaxe em C, problemas no Flex/Bison), os testes são interrompidos e o erro é exibido, fornecendo feedback imediato sobre problemas na base do código.

### 2\. Validação da Saída de Debug

O teste principal, `test_saida_de_debug_do_compilador`, valida a lógica do analisador léxico e sintático de forma sistemática:

1.  **Descoberta de Testes:** O script varre a pasta `tests/entradas/` em busca de todos os arquivos de cenário `entrada*.txt`.
2.  **Execução por Cenário:** Para cada arquivo de entrada encontrado, o teste executa os seguintes passos:

      - **Leitura:** Carrega o conteúdo do código-fonte de `entradaX.txt` e a saída de debug esperada do arquivo correspondente `saidaX.txt`.
      - **Execução do Compilador:** O executável `compilador` é chamado, e o código-fonte é passado para ele via entrada padrão (`stdin`).
      - **Captura da Saída:** A saída de debug, que nosso compilador emite na saída de erro padrão (`stderr`), é capturada em tempo real.
      - **Comparação:** A parte crucial: a saída de debug real é comparada, linha por linha, com o conteúdo do arquivo de saída esperado.
      - **Validação:** Qualquer divergência resulta em uma falha no teste, que aponta exatamente qual cenário (`entradaX.txt`) não se comportou como o esperado, facilitando a depuração.

## Objetivo Principal dos Testes

Nesta fase do desenvolvimento, o objetivo central é garantir que o **analisadores léxico** está funcionando corretamente. A estratégia de comparar a saída de debug (`stderr`) é uma forma eficaz de "ver o que o compilador está pensando".

Os testes validam se o compilador consegue:

  - Identificar corretamente palavras-chave (`if`, `def`, `while`).
  - Reconhecer identificadores, números, strings e operadores.
  - Processar a estrutura de indentação, gerando os tokens `INDENT` e `DEDENT` nos locais corretos.

Essencialmente, estamos validando se o fluxo de tokens corresponde exatamente ao esperado para cada código de entrada.

## Como Executar os Testes Localmente

Para rodar o conjunto de testes no seu ambiente de desenvolvimento, certifique-se de que as dependências (`pytest`, `flex`, `bison`) estão instaladas e execute o seguinte comando na raiz do projeto:

```bash
pytest .
```

## Referências

‌FREITAS, Sergio. **COMP 1**. Disponível em: <[https://github.com/sergioaafreitas](https://github.com/sergioaafreitas)>. Acesso em: 30 set. 2025.

## Tabela de Versionamento

| Versão | Data       | Autor     | Descrição                                 |
|--------|------------|-----------|--------------------------------------------|
| `1.0`    | 30/09/2025 | [Ana Luiza Soares](https://github.com/Ana-Luiza-SC) | Criação inicial da documentação de testes. |

