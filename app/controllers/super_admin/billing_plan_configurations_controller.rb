class SuperAdmin::BillingPlanConfigurationsController < SuperAdmin::ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = AccountBillingPlan::PLANS.keys.index_with { |k| merged_plan_details(k) }
    @plan_stats = {}

    # Estatísticas de uso por plano
    AccountBillingPlan.group(:plan_name).count.each do |plan_name, count|
      @plan_stats[plan_name] = {
        accounts_count: count,
        total_agents: Account.joins(:billing_plan).where(account_billing_plans: { plan_name: plan_name }).joins(:users).count,
        total_inboxes: Account.joins(:billing_plan).where(account_billing_plans: { plan_name: plan_name }).joins(:inboxes).count
      }
    end
  end

  def show
    @plan_name = params[:id]
    @plan_details = merged_plan_details(@plan_name)

    unless @plan_details
      redirect_to super_admin_billing_plan_configurations_path, alert: 'Plano não encontrado'
      return
    end

    @accounts_with_plan = Account.joins(:billing_plan).where(account_billing_plans: { plan_name: @plan_name })
  end

  def new
    @plan_name = params[:plan_name]
    @plan_details = AccountBillingPlan::PLANS[@plan_name] || {}
  end

  def edit
    @plan_name = params[:id]
    @plan_details = merged_plan_details(@plan_name)
    @override = current_overrides[@plan_name] || {}

    return if @plan_details

    redirect_to super_admin_billing_plan_configurations_path, alert: 'Plano não encontrado'
    return
  end

  def create
    @plan_name = params[:plan_name]
    @plan_details = AccountBillingPlan::PLANS[@plan_name]

    unless @plan_details
      redirect_to super_admin_billing_plan_configurations_path, alert: 'Plano não encontrado'
      return
    end

    # Atualizar configurações do plano (se necessário)
    # Por enquanto, apenas redirecionamos
    redirect_to super_admin_billing_plan_configuration_path(@plan_name), notice: 'Configurações do plano atualizadas com sucesso!'
  end

  def update
    @plan_name = params[:id]
    @plan_details = merged_plan_details(@plan_name)

    unless @plan_details
      redirect_to super_admin_billing_plan_configurations_path, alert: 'Plano não encontrado'
      return
    end

    overrides = current_overrides

    # Normaliza parâmetros (como Hash) para evitar UnfilteredParameters
    sanitized = plan_config_params.to_h
    sanitized['features'] = sanitized['features'].to_s.split(',').map(&:strip).reject(&:blank?) if sanitized['features'].present?
    if sanitized['limits'].present?
      sanitized['limits'] = sanitized['limits'].transform_values { |v| v.to_s.strip.presence }.compact
      sanitized['limits'].transform_values! { |v| v == '-1' ? -1 : v.to_i }
    end
    sanitized['price'] = sanitized['price'].to_s.strip.presence&.to_i if sanitized.key?('price')

    # Garante estrutura e realiza merge seguro
    plan_override = (overrides[@plan_name] || {})
    overrides[@plan_name] = plan_override.merge(sanitized)

    record = InstallationConfig.where(name: 'BILLING_PLANS_OVERRIDES').first_or_create(value: {}, locked: false)
    record.update!(value: overrides, locked: false)

    redirect_to super_admin_billing_plan_configuration_path(@plan_name), notice: 'Configurações do plano atualizadas com sucesso!'
  end

  def destroy
    @plan_name = params[:id]

    # Verificar se há contas usando este plano
    accounts_count = Account.joins(:billing_plan).where(account_billing_plans: { plan_name: @plan_name }).count

    if accounts_count > 0
      redirect_to super_admin_billing_plan_configurations_path,
                  alert: "Não é possível excluir o plano '#{@plan_name}'. Existem #{accounts_count} conta(s) usando este plano."
      return
    end

    # Aqui você poderia implementar a lógica para desativar/remover o plano
    redirect_to super_admin_billing_plan_configurations_path, notice: 'Plano removido com sucesso!'
  end

  private

  def set_plan
    @plan_name = params[:id]
    @plan_details = AccountBillingPlan::PLANS[@plan_name]
  end

  def current_overrides
    GlobalConfig.get('BILLING_PLANS_OVERRIDES')['BILLING_PLANS_OVERRIDES'] || {}
  rescue StandardError
    {}
  end

  def merged_plan_details(plan_name)
    base = (AccountBillingPlan::PLANS[plan_name] || {}).deep_dup
    ov = current_overrides[plan_name] || {}
    base[:price] = ov[:price] if ov.key?(:price)
    base[:name] = ov[:name] if ov[:name].present?
    if ov[:limits].is_a?(Hash)
      base[:limits] ||= {}
      base[:limits].merge!(ov[:limits].symbolize_keys)
    end
    base[:features] = ov[:features] if ov[:features].present?
    base
  end

  def plan_config_params
    params.require(:billing_plan_configuration).permit(
      :name,
      :price,
      :features,
      limits: %i[agents inboxes conversations_per_month contacts storage_mb llm_credits]
    )
  end
end
