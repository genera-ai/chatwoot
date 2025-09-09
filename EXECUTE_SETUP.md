# Genera Atende - Setup de Desenvolvimento (WSL-friendly)

Este guia prepara um ambiente de desenvolvimento consistente para o fork do Chatwoot com as customizações do Genera Atende.

## Pré-requisitos
- Docker + Docker Compose
- Ruby via rbenv (3.2.0)
- Node.js 18+ (com corepack)

## 1) Containers de infraestrutura
```bash
# Sobe Postgres (com pgvector) e Redis
./bin/docker_dev.sh start
```

## 2) Configurar ambiente de shell (WSL)
```bash
# rbenv (se disponível)
source ~/.bashrc || true
eval "$(rbenv init - bash)" || true
rbenv global 3.2.0 && rbenv rehash || true

# pnpm via corepack
corepack enable || true
corepack prepare pnpm@10.2.0 --activate || true
```

## 3) Dependências do projeto
```bash
bundle install
pnpm install
```

## 4) Banco de dados
```bash
bundle exec rails db:migrate
bundle exec rails db:seed
```

## 5) Rodando o projeto
```bash
# Com overmind (recomendado)
overmind start -f ./Procfile.dev

# ou via pnpm
pnpm dev
```

- App: http://localhost:3000
- Dashboard Genera Atende: http://localhost:3000/genera_atende/dashboard

## Notas
- Postgres com pgvector: definido em `docker-compose.dev.yml` e `docker/postgres/init.sql`.
- Variáveis: `.env.development` (copiado para `.env` no primeiro setup).
- Se ocorrerem permissões EACCES no `node_modules`, garanta que o projeto pertence ao seu usuário:
```bash
sudo chown -R $USER:$USER /home/$USER/projetos/genera-atende
```
