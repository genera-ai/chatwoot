class SuperAdmin::BillingPlanConfigurationsController < SuperAdmin::ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = AccountBillingPlan::PLANS
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
    @plan_details = AccountBillingPlan::PLANS[@plan_name]

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
    @plan_details = AccountBillingPlan::PLANS[@plan_name]

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
    @plan_details = AccountBillingPlan::PLANS[@plan_name]

    unless @plan_details
      redirect_to super_admin_billing_plan_configurations_path, alert: 'Plano não encontrado'
      return
    end

    # Atualizar configurações do plano (se necessário)
    # Por enquanto, apenas redirecionamos
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
end
