# Setup do Ambiente - Genera Atende

Siga estes passos para preparar um ambiente de desenvolvimento estável (WSL/Ubuntu 22.04):

## 1. Pré-requisitos
- Docker + Docker Compose
- rbenv (Ruby 3.2.0)
- Node.js 18+ (com corepack)

## 2. Infraestrutura
```bash
./bin/docker_dev.sh start
```

## 3. Ambiente de shell
```bash
source ~/.bashrc || true
eval "$(rbenv init - bash)" || true
rbenv global 3.2.0 && rbenv rehash || true
corepack enable || true
corepack prepare pnpm@10.2.0 --activate || true
```

## 4. Dependências e DB
```bash
bundle install
pnpm install
bundle exec rails db:migrate
bundle exec rails db:seed
```

## 5. Rodar a aplicação
```bash
overmind start -f ./Procfile.dev
# ou
pnpm dev
```

Acesse:
- http://localhost:3000
- http://localhost:3000/genera_atende/dashboard

## 6. Configuração
- Copie `docs/setup-config.example.env` para `.env` e ajuste se necessário.
- Postgres com pgvector já configurado em `docker-compose.dev.yml`.

## Credenciais (Seeds)
- Usuário: `john@acme.inc`
- Senha: `Password1!`
