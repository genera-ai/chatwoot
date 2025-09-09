# Billing - Asaas (MVP)

Integração mínima com a API do Asaas via `Custom::Billing::AsaasGateway`.

## Variáveis de ambiente
- `BILLING_GATEWAY=asaas`
- `ASAAS_API_KEY=...` (obrigatório)
- `ASAAS_ENV=sandbox` (opcional; default: produção)
- `ASAAS_BASE_URL=https://sandbox.asaas.com/api/v3` (opcional)

## Endpoints usados (resumo)
- Customers
  - GET `/customers?email=`
  - POST `/customers`
- Subscriptions
  - POST `/subscriptions`
  - POST `/subscriptions/{id}/cancel`
- Invoices
  - GET `/payments?subscription={id}`

Auth: header `access_token: <API_KEY>`.

## Uso
```ruby
ENV['BILLING_GATEWAY'] = 'asaas'
ENV['ASAAS_API_KEY'] = 'your_sandbox_key'
ENV['ASAAS_ENV'] = 'sandbox'

svc = Custom::Billing::Service.new
tenant = GeneraAtende::Tenant.first
plan = GeneraAtende::BillingPlan.first

svc.subscribe!(tenant: tenant, plan: plan)
svc.invoices(tenant: tenant)
svc.cancel!(tenant: tenant)
```

## Notas
- Esta implementação é mínima (MVP) e não trata tokenização de cartão nem webhooks.
- Para produção, habilitar webhooks do Asaas para sincronizar estados de pagamentos e faturas.
