# Projeto Banco de Dados – Rede Social

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
git clone https://github.com/Miria-Kelly/Rede_Social/tree/Jonathan/docker-setup
```
2. Acesse a pasta raiz do projeto no terminal:
```bash
cd Rede_Social/tree/Jonathan/docker-setup
```
3.Suba os containers Docker:
```bash
docker-compose up --build
```

## 2 Esquema conceitual do Banco de Dados

![Esquema Conceitual do Banco de Dados](/docs/esquema_conceitual.jpg)

## 3 Dicionário de Dados

 O dicionário de dados encontra-se no arquivo pdf abaixo, contendo descrição das tabelas, atributos, tipos de dados e restrições
 [Acessar Dicionário de Dados](./docs/dicionario_dados.pdf)

## 4 Povoamento do Banco de Dados

O banco de dados é inicializado e povoado automaticamente por meio do script SQL init.sql.
Esse script é executado durante a primeira criação do container do banco de dados, no processo de subida da aplicação via Docker.

O init.sql é responsável por:

1. Criar toda a estrutura do banco de dados (tabelas, chaves primárias e estrangeiras);
2. Inserir dados iniciais para fins de teste, como perfis, relacionamentos, conversas, publicações e interações.

O processo ocorre de forma automática quando o container é criado, não sendo necessária nenhuma intervenção manual para a criação ou o povoamento do banco.

Importante:
O script init.sql é executado apenas na primeira criação do volume do banco de dados. Caso o container já tenha sido iniciado anteriormente, o script não será executado novamente. Para recriar o banco e reaplicar o povoamento inicial, é necessário remover os volumes do Docker antes de subir os containers novamente.

Exemplo:
```bash
docker compose down -v
docker compose up --build
```

