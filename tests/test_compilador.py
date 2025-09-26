import os
import subprocess
import pytest

# --- Configuração dos Caminhos ---
# Pega o diretório do arquivo de teste atual para montar os outros caminhos
TEST_SCRIPT_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.join(TEST_SCRIPT_DIR, '..')

# Caminho para o executável do compilador
COMPILADOR_EXEC = os.path.join(PROJECT_ROOT, 'compilador')
# Caminhos para as pastas de entrada e saída dos testes
ENTRADAS_DIR = os.path.join(TEST_SCRIPT_DIR, 'entradas')
SAIDAS_DIR = os.path.join(TEST_SCRIPT_DIR, 'saidas')


# --- Fixture: Compila o código C antes de rodar os testes ---
# (scope="module") faz com que isso rode apenas uma vez por sessão de testes
@pytest.fixture(scope="module", autouse=True)
def compile_compiler():
    """Compila o projeto C para garantir que o executável está atualizado."""
    print("\n(Re)compilando o projeto C...")
    
    # O comando exato que você usa para compilar
    compile_command = "flex lexer/lexer.l && bison -d parser/parser.y && gcc -o compilador lex.yy.c parser.tab.c -lfl"
    
    # Roda o comando a partir da raiz do projeto
    result = subprocess.run(compile_command, shell=True, capture_output=True, text=True, cwd=PROJECT_ROOT)
    
    # Se a compilação falhar, todos os testes são interrompidos
    assert result.returncode == 0, f"A compilação falhou:\n{result.stderr}"
    print("Compilação bem-sucedida.")
    yield # Permite que os testes rodem

def test_saida_de_debug_do_compilador():
    """
    Encontra todos os 'entrada*.txt', roda o compilador para cada um,
    e compara a saída de debug (stderr) com o 'saida*.txt' correspondente.
    """
    input_files = [f for f in os.listdir(ENTRADAS_DIR) if f.startswith('entrada') and f.endswith('.txt')]
    
    assert len(input_files) > 0, f"Nenhum arquivo 'entrada*.txt' encontrado em {ENTRADAS_DIR}"
    
    for input_file_name in input_files:
        # Ex: 'entrada1.txt' -> 'saida1.txt'
        expected_output_name = input_file_name.replace('entrada', 'saida')
        
        input_file_path = os.path.join(ENTRADAS_DIR, input_file_name)
        expected_output_path = os.path.join(SAIDAS_DIR, expected_output_name)
        
        print(f"\n-> Testando: {input_file_name}")

        try:
            with open(input_file_path, 'r') as f_in:
                input_code = f_in.read()
            
            with open(expected_output_path, 'r') as f_exp:
                expected_stderr = f_exp.read()
        except FileNotFoundError as e:
            pytest.fail(f"Arquivo de teste ou de saída esperada não encontrado: {e.filename}")

        # Roda o compilador, passando o código via stdin
        result = subprocess.run(
            [COMPILADOR_EXEC],
            input=input_code,
            capture_output=True,
            text=True
        )
        
        # Pega a saída de debug real do canal stderr
        actual_stderr = result.stderr
        
        # Compara a saída real com a esperada
        assert actual_stderr == expected_stderr, f"Falha no teste {input_file_name}"