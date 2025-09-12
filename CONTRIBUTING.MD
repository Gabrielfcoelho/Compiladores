# Guia de Contribuição

Agradecemos o seu interesse em contribuir com o projeto\! Para manter a organização, a clareza do histórico e a qualidade do código, pedimos que siga as regras descritas abaixo.

## Regra de Ouro: Comece com uma Issue

Nenhuma alteração deve ser feita diretamente na `main` ou sem uma issue correspondente. Antes de começar a codificar, certifique-se de que existe uma issue para a sua tarefa e que ela foi designada a você.

## Fluxo de Trabalho Completo

1.  **Crie uma Branch a partir da `main`**: Sempre comece seu trabalho a partir da versão mais atualizada da branch `main`.

2.  **Use o Padrão de Nomenclatura para a Branch**: A sua branch **deve** seguir o formato `termo(#numissue)-definicao-em-kebab-case`.

      * `termo`: Um dos tipos definidos na seção "Padrões de Commits".
      * `#numissue`: O número da issue que você está resolvendo.
      * `definicao-em-kebab-case`: Uma breve descrição do objetivo da branch, em português, com palavras separadas por hífens.

    **Exemplo:**

    ```bash
    git checkout -b "feat(#4)-implementar-parser-inicial"
    ```

3.  **Faça Commits Semânticos**: Cada commit deve ser atômico e seguir o padrão de nomenclatura `termo(#numissue) - definicao em frase`, sendo a frase descrita em português.

    **Exemplo:**

    ```bash
    git commit -m "feat(#4) - adiciona regras gramaticais para declaracoes"
    ```

4.  **Abra um Pull Request (PR)**: Após finalizar o trabalho na sua branch, abra um Pull Request para a `main`. A descrição do PR deve explicar o que foi feito e como isso resolve a issue associada.

## Processo de Revisão (Code Review)

Para que uma alteração seja integrada (`merge`) à branch `main`, o Pull Request deve ser revisado e aprovado por, no mínimo, **um integrante da equipe que não seja o autor** do código.

-----

## Padrões de Commits 📜

De acordo com a documentação do **[Conventional Commits](https://www.conventionalcommits.org/pt-br)**, utilizamos os seguintes tipos para garantir um histórico de commits explícito e legível.

### Tipo e descrição 🦄

  - `feat`: Inclui um **novo recurso**.
  - `fix`: **Soluciona um problema** (bug fix).
  - `docs`: **Mudanças na documentação** (ex: README).
  - `test`: **Alterações em testes** (criação, alteração, exclusão).
  - `build`: Modificações em **arquivos de build e dependências**.
  - `perf`: Alterações de código relacionadas a **performance**.
  - `style`: **Formatações de código** que não alteram a lógica (ponto e vírgula, linting, etc.).
  - `refactor`: **Refatorações de código** que não alteram sua funcionalidade final.
  - `chore`: **Atualizações de tarefas** de build, configurações, pacotes (`.gitignore`, etc.).
  - `ci`: Mudanças relacionadas à **integração contínua** (Continuous Integration).
  - `raw`: Mudanças em arquivos de configurações, dados, features ou parâmetros.
  - `cleanup`: Remoção de código comentado ou qualquer outra **limpeza de código**.
  - `remove`: Exclusão de arquivos, diretórios ou funcionalidades obsoletas.

