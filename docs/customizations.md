# Customizações - Genera Atende

## Resumo
Customizações SaaS adicionadas mantendo compatibilidade com o core do Chatwoot.

## Backend (Rails)
- Namespace `GeneraAtende` (models/controllers)
- Rotas em `config/routes.rb` (`namespace :genera_atende`)
- Initializer `config/initializers/genera_atende.rb`
- Migrations `db/migrate/20240115...` para tenants/workspaces/billing
- Seeds adicionais em `db/seeds/genera_atende.rb`

## Frontend (Vue/Tailwind)
- Componentes em `app/javascript/dashboard/components-genera/**`
- Cores de marca no `tailwind.config.js`

## Infra
- Docker Compose com Postgres (pgvector) e Redis em `docker-compose.dev.yml`
- Init SQL em `docker/postgres/init.sql`
- Scripts utilitários em `bin/docker_dev.sh`, `bin/setup_genera_atende`

## Notas de manutenção
- Evitar alterar core do Chatwoot; preferir hooks/serviços/overrides isolados
- Manter `develop` limpo e branchs `custom/*` para camadas SaaS
- Verificar compatibilidade com `enterprise/` se aplicável
