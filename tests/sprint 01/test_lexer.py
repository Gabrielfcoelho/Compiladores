import pytest
import os
import subprocess
import tempfile       

class TestLexer:
    @classmethod
    def setup_class(cls):
        """Compila o lexer antes dos testes"""
        os.system("cd src && flex lexer.l && bison -d parser.y && gcc -o parser parser.tab.c lex.yy.c -lfl")
    
    def test_numbers(self):
        """Testa reconhecimento de números"""
        result = self._run_lexer("123")
        assert result == ""
    
    def test_operators(self):
        """Testa reconhecimento de operadores"""
        operators = ["+", "-", "*", "/", "(", ")"]
        for op in operators:
            result = self._run_lexer(op)
            assert result == f"Erro sintático: syntax error\n"

    def test_expression(self):
        """Testa expressão completa"""
        result = self._run_lexer("123 + 456")
        print(result)
        assert result == ""

    def test_invalid_character(self):
        """Testa caractere inválido"""
        result = self._run_lexer("@")
        assert 'Caractere inválido: @' in result
    def _run_lexer(self, input_text):
        """Executa o lexer com entrada específica"""
        with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
            f.write(input_text)
            f.flush()
            
        result = subprocess.run(
            ["./src/parser"], 
            stdin=open(f.name), 
            capture_output=True, 
            text=True
        )

        os.unlink(f.name)
        return result.stdout + result.stderr