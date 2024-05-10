# README

# CEP Lookup API

Bem-vindo à documentação da CEP Lookup API! Este README fornecerá informações sobre como configurar e usar a API.

## Configuração

1. Clone este repositório:

    ```bash
    git clone https://github.com/andrademarciane/cep-lookup-api.git
    ```

2. Navegue até o diretório da API:

    ```bash
    cd cep-lookup-api
    ```
## Executando com Docker

### Requisitos

Certifique-se de ter o Docker e o Docker Compose instalados na sua máquina antes de prosseguir.

### Instruções

Para executar a aplicação usando Docker, siga estas etapas:

1. **Construa a imagem Docker:**

    ```bash
    docker build .
    ```

2. **Configure o Docker Compose:**

    Primeiro, navegue até o diretório de desenvolvimento:

    ```bash
    cd development/
    ```

    Em seguida, instale as dependências do Ruby:

    ```bash
    docker-compose run web bundle install
    ```

    Após a instalação das dependências, crie o banco de dados, execute as migrações e preencha-o com dados de exemplo:

    ```bash
    docker-compose run web rails db:setup
    docker-compose run web rails db:migrate
    docker-compose run web rails db:seed
    ```

3. **Execute o Docker Compose:**

    Com tudo configurado, inicie os contêineres com o Docker Compose:

    ```bash
    docker-compose up
    ```

    A API estará disponível em `http://0.0.0.0:3000`.

## Executando sem Docker

### Requisitos

Antes de iniciar sem Docker, certifique-se de atender aos seguintes requisitos:

- Instale a versão 3.0.6 do Ruby na sua máquina.
- Crie um arquivo `.env` na raiz do projeto. Você pode usar o arquivo `.env.sample` como modelo.

### Configuração do Banco de Dados

Esta aplicação utiliza PostgreSQL como banco de dados. Certifique-se de ter o PostgreSQL instalado e configurado corretamente. Você pode ajustar as credenciais do banco de dados no arquivo `config/database.yml`.

### Configuração do Sidekiq com Redis 7.0 ou Similar

Esta aplicação utiliza Sidekiq para processamento de tarefas em segundo plano com Redis. Certifique-se de ter o Redis instalado e configurado corretamente. Você pode ajustar as conexões do Sidekiq com o Redis no arquivo `config/initializers/sidekiq.rb`.

## Documentação da API

Para facilitar o teste da API, existe um JSON do Postman. Este arquivo JSON está localizado na pasta `docs` do projeto.

Para importar essas requisições para o Postman, siga estas etapas:

1. Baixe o arquivo JSON com as requisições da API do diretório `docs` no GitHub.

2. Abra o Postman e clique no botão "Import".

3. Selecione a opção "Import File" e selecione o arquivo JSON que você baixou.

4. Após a importação, todas as requisições da API estarão disponíveis no Postman para teste e execução.
