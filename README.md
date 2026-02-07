# Rede_Social# Projeto Banco de Dados – Rede Social

## Descrição do Projeto
Este projeto consiste no desenvolvimento de um banco de dados relacional para uma rede social que permite que o usuário interaja com outros por meio de conversas ou interações e realize publicações.
O banco foi modelado, implementado e povoado utilizando Docker.

## 1 Como Executar o Projeto

### Pré-requisitos
- Docker instalado
- Docker Compose instalado
- Git

### Passos para execução

1. Clone o repositório:
```bash
git clone https://github.com/Miria-Kelly/Rede_Social.git
```
2. Acesse a pasta raiz do projeto no terminal:
```bash
cd Rede_Social
```
3.Suba os containers Docker:
```bash
docker-compose up --build
```
4. Acesse a API pelo POSTMAN

## 2 Esquema conceitual do Banco de Dados

![Esquema Conceitual do Banco de Dados](/docs/esquema_conceitual.jpg)

## 3 Dicionário de Dados

 O dicionário de dados encontra-se no arquivo pdf abaixo, contendo descrição das tabelas, atributos, tipos de dados e restrições
 [Acessar Dicionário de Dados](./docs/dicionario_dados.pdf)

## 4 Povoamento do Banco de Dados

O banco de dados foi povoado por meio de uma API desenvolvida em Python utilizando FastAPI, responsável por inserir registros nas tabelas principais do sistema através de requisições HTTP.
A API realiza conexão direta com o MySQL utilizando a biblioteca mysql.connector, permitindo a criação de perfis, relacionamentos de seguidores, publicações, interações e mensagens.

O povoamento foi realizado via requisições no Postman, utilizando os endpoints:


### POST /criar
Responsável por inserir novos registros na tabela Perfil.

### POST /seguir
Insere registros na tabela Segue.
Além disso, ao realizar um seguimento válido, o sistema cria automaticamente uma conversa entre os perfis caso ainda não exista.

### POST /publicar
Insere uma nova publicação na tabela Publicacao e também cria o registro correspondente na tabela Arquivo_midia.

### POST /interacao
Registra uma interação na tabela Interacao.
Dependendo do tipo (curtida ou comentario), também insere dados na subentidade correspondente (Interacao_curtida
Interacao_comentario)

### POST /mensagem
Insere mensagens na tabela Mensagem, vinculadas a uma conversa e a um perfil.

### POST /conversa
Cria conversas privadas na tabela Conversa e registra os participantes na tabela Participa.