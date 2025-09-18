# Customizações do Genera Atende

Este documento registra todas as customizações feitas no Chatwoot para criar o Genera Atende, um SaaS multitenant.

## Arquitetura

O projeto segue uma arquitetura em camadas:
- **core**: Chatwoot original (mantido limpo)
- **custom**: Funcionalidades SaaS específicas do Genera Atende
- **infra**: CI/CD, Kubernetes, Docker

## Customizações Implementadas

### 1. Sistema de Billing e Planos

**Arquivos modificados:**
- `app/models/account_billing_plan.rb` - Modelo de planos de billing
- `app/services/billing_plan_service.rb` - Serviço de gerenciamento de planos
- `app/controllers/super_admin/billing_plans_controller.rb` - Controller para gerenciar planos
- `app/views/super_admin/billing_plans/show.html.erb` - Interface de gerenciamento de planos
- `app/helpers/billing_plans_helper.rb` - Helpers para billing
- `config/locales/en.billing_plans.yml` - Traduções para billing
- `config/routes.rb` - Rotas para billing

**Funcionalidades:**
- Planos de billing (Free, Starter, Professional, Enterprise)
- Limites por plano (agentes, inboxes, conversas, contatos, storage, créditos LLM)
- Interface moderna para gerenciamento de planos
- Sistema de créditos LLM
- Pausar/retomar planos
- Modal de confirmação para mudanças de plano

### 2. Painel de Administração

**Arquivos modificados:**
- `app/controllers/super_admin/accounts_controller.rb` - Controller de contas
- `app/dashboards/account_dashboard.rb` - Dashboard de contas
- `app/fields/billing_plan_actions_field.rb` - Campo customizado para ações de billing
- `app/views/super_admin/accounts/index.html.erb` - Interface de listagem de contas

**Funcionalidades:**
- Interface moderna com cards
- Busca e filtros avançados
- Ações de gerenciamento de billing
- Integração com sistema de planos

### 3. Sincronização com Upstream

**Processo de sincronização:**
1. `git fetch upstream` - Busca atualizações do Chatwoot original
2. `git merge upstream/develop` - Mescla mudanças na branch develop
3. Criação de PR para review das mudanças
4. Merge após aprovação

**Última sincronização:**
- Data: $(date)
- Commit: 4014a846f (feat: Add the frontend support for MFA)
- Principais mudanças: MFA, melhorias em automações, WhatsApp templates

## Estratégias de Manutenção

### 1. Isolamento de Customizações
- Customizações em arquivos separados quando possível
- Uso de services e helpers para lógica customizada
- Evitar modificações diretas no core do Chatwoot

### 2. Rebase Strategy
- Manter customizações em branches separadas
- Rebase regular com upstream
- Testes automatizados para garantir compatibilidade

### 3. Documentação
- Este arquivo deve ser atualizado a cada customização
- Comentários no código explicando mudanças
- README específico para customizações

## Próximas Customizações Planejadas

1. **Sistema Multitenant Completo**
   - Provisionamento automatizado de workspaces
   - Isolamento de dados por tenant
   - Gestão de recursos por tenant

2. **Integração com Billing Externo**
   - Stripe/Pagar.me/Asaas
   - Webhooks de pagamento
   - Faturamento automático

3. **Painel de Administração Avançado**
   - Métricas de uso por tenant
   - Gestão de usuários centralizada
   - Relatórios de billing

## Testes

### Backend
```bash
bundle exec rspec spec/path/to/file_spec.rb
```

### Frontend
```bash
pnpm test
```

### Linting
```bash
# Ruby
bundle exec rubocop -a

# JavaScript/Vue
pnpm eslint
```

## Contato

Para dúvidas sobre customizações, consulte a equipe de desenvolvimento do Genera Atende.
