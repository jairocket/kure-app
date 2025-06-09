
#  ![Screenshot from 2025-05-24 12-46-01](https://github.com/user-attachments/assets/a612d6c4-e1d6-4cef-96c0-d645ad2b1adf) Kure

Sua aplicação para gerenciamento de consultas médicas.

## Programação Para Dispositivos Móveis Em Android

### Centro Universitário Uniruy

### Alunos

- Jailson Jesus dos Anjos
- Luiz Felipe Barreto Silveira
- Fernando Santana de Morais
- Rui Romer Cupertino Sacramento Júnior

### Professor

- Pedro Kislanski

### Funcionalidades:

- Cadastro de usuário (médico)
- Troca de senha de usuário (médico)
- Login com validação de senha
- Cadastro de Paciente
- Api Externa
  - [Via CEP](https://viacep.com.br/), utilizada para cadastramento do endereço do paciente
- Marcação de consulta
- Cancelamento de consulta
- Visualizar consultas do dia (home)
- Pesquisar consultas agendadas por CPF de paciente
- Remarcar consultas (pesquise pelo CPF e clique no nome do paciente)
- Tela de Relatório
  - Gráfico com consultas faturadas, previstas e canceladas;
  - Discriminação das receitas 
  - Gráfico com a receita estimada (receita decorrente de consultas faturadas + receita decorrente de consultas previstas)
- Dados persistidos com uso do [SQFLITE](https://pub.dev/packages/sqflite)
