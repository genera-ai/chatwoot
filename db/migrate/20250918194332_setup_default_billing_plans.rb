class SetupDefaultBillingPlans < ActiveRecord::Migration[7.1]
  def up
    # Configurar planos de billing para contas existentes
    setup_billing_plans_for_existing_accounts

    # Configurar instalação como enterprise (opcional)
    setup_enterprise_configuration
  end

  def down
    # Remover billing plans criados por esta migração
    AccountBillingPlan.where(plan_name: 'free').destroy_all

    # Reverter configurações de instalação
    revert_enterprise_configuration
  end

  private

  def setup_billing_plans_for_existing_accounts
    puts '🚀 Configurando planos de billing para contas existentes...'

    # Obter todas as contas sem billing plan
    accounts_without_billing = Account.left_joins(:billing_plan).where(account_billing_plans: { id: nil })

    if accounts_without_billing.empty?
      puts '✅ Todas as contas já possuem billing plan'
      return
    end

    puts "📊 Encontradas #{accounts_without_billing.count} contas sem billing plan"

    accounts_without_billing.each_with_index do |account, index|
      puts "#{index + 1}. Configurando conta: #{account.name} (ID: #{account.id})"

      # Determinar plano baseado no nome da conta ou usar padrão
      plan_name = determine_plan_name(account)

      # Criar billing plan
      billing_plan = account.create_billing_plan!(
        plan_name: plan_name,
        active: true,
        payment_status: 'active'
      )

      # Atualizar contadores de uso
      billing_plan.update!(
        current_agents_count: account.account_users.count,
        current_inboxes_count: account.inboxes.count,
        current_conversations_count: account.conversations.count
      )

      puts "   ✅ Plano '#{plan_name}' configurado com sucesso"
    end

    puts '✅ Configuração de planos concluída!'
  end

  def determine_plan_name(account)
    case account.name.downcase
    when /enterprise|premium/
      'enterprise'
    when /professional|pro/
      'professional'
    when /starter|basic/
      'starter'
    else
      'free' # Plano padrão
    end
  end

  def setup_enterprise_configuration
    puts '🏢 Configurando instalação como Enterprise...'

    # Configurar plano como enterprise
    plan_config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
    plan_config.value = 'enterprise'
    plan_config.locked = true
    plan_config.save!

    # Configurar quantidade de licenças
    quantity_config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')
    quantity_config.value = 100
    quantity_config.locked = true
    quantity_config.save!

    # Habilitar signup de contas
    signup_config = InstallationConfig.find_or_initialize_by(name: 'ENABLE_ACCOUNT_SIGNUP')
    signup_config.value = true
    signup_config.locked = false
    signup_config.save!

    # Habilitar criação de contas do dashboard
    dashboard_config = InstallationConfig.find_or_initialize_by(name: 'CREATE_NEW_ACCOUNT_FROM_DASHBOARD')
    dashboard_config.value = true
    dashboard_config.locked = false
    dashboard_config.save!

    puts '✅ Configurações Enterprise aplicadas:'
    puts "   INSTALLATION_PRICING_PLAN: #{plan_config.value}"
    puts "   INSTALLATION_PRICING_PLAN_QUANTITY: #{quantity_config.value}"
    puts "   ENABLE_ACCOUNT_SIGNUP: #{signup_config.value}"
    puts "   CREATE_NEW_ACCOUNT_FROM_DASHBOARD: #{dashboard_config.value}"
  end

  def revert_enterprise_configuration
    # Reverter para configurações padrão
    InstallationConfig.where(name: 'INSTALLATION_PRICING_PLAN').update_all(value: 'free', locked: false)
    InstallationConfig.where(name: 'INSTALLATION_PRICING_PLAN_QUANTITY').update_all(value: '1', locked: false)
    InstallationConfig.where(name: 'ENABLE_ACCOUNT_SIGNUP').update_all(value: false, locked: false)
    InstallationConfig.where(name: 'CREATE_NEW_ACCOUNT_FROM_DASHBOARD').update_all(value: false, locked: false)
  end
end
