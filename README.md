# Compilador Python -> Ruby

Projeto realizado para a disciplina de Compiladores 1 ministrada pelo professor Dr. Sérgio Freitas na Universidade de Brasília (UnB).

## Introdução

O objetivo deste projeto é desenvolver um compilador que traduza código escrito em Python para Ruby. Ambos são linguagens de alto nível, dinâmicas e interpretadas. Foram consideradas algumas decisões técnicas para a escolha dessas linguagens:

- **Sintaxe Simples**: Python e Ruby possuem sintaxes relativamente simples e legíveis, o que facilita a tradução entre elas.
- **Popularidade**: Ambas as linguagens são amplamente utilizadas na indústria, o que torna o projeto relevante.

## Requisitos do Sistema

- Python 3.x
- Flex
- Bison

## Execução

1. Clone o repositório:

   ```bash
   git clone
   ```

2. Instale as dependências necessárias (se houver).

   ```bash
   pip install -r requirements.txt &&
   sudo apt-get install flex bison
   ```

3. Execute o makefile para compilar o projeto:

   ```bash
   make
   ```

4. Execute os testes:
   ```bash
   pytest .
   ```

## Integrantes do Grupo

<div align="center">
    <table align="center">
        <tr>
            <td align="center">
                <img src="https://avatars.githubusercontent.com/u/138021508?v=4" width="100px;" /><br>
                <a href="https://github.com/Ana-Luiza-SC">Ana Luiza Soares</a>
            </td>
            <td align="center">
                <img src="https://avatars.githubusercontent.com/u/127219960?v=4" width="100px;" /><br>
                <a href="https://github.com/Gabrielfcoelho">Gabriel Flores Coelho</a>
            </td>
            <td align="center">
                <img src="https://avatars.githubusercontent.com/u/163934412?v=4" width="100px;" /><br>
                <a href="https://github.com/JoaoSapiencia">João Victor Sapiencia</a>
            </td>
            <td align="center">
                <img src="https://avatars.githubusercontent.com/u/165099836?v=4" width="100px;" /><br>
                <a href="https://github.com/VilmarFagundes">Vilmar Fagundes</a>
            </td>
            <td align="center">
                <img src="https://avatars.githubusercontent.com/u/107211702?v=4" width="100px;" /><br>
                <a href="https://github.com/matheusdealcantara">Matheus de Alcântara</a>
            </td>
        </tr>
    </table>
</div>

## Histórico de Versão

<div align="center">
    <table align="center">
        <thead>
            <tr>
                <th>Data</th>
                <th>Versão</th>
                <th>Descrição</th>
                <th>Autor</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td align="center">2025-09-10</td>
                <td align="center"><code>1.0</code></td>
                <td align="center">Criação do documento inicial</td>
                <td align="center"><a href="https://github.com/matheusdealcantara">Matheus de Alcântara</a></td>
            </tr>
        </tbody>
    </table>
</div>
