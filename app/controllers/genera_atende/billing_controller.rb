# frozen_string_literal: true

module GeneraAtende
  class BillingController < GeneraAtende::ApplicationController
    before_action :ensure_admin_access, only: [:update_plan, :cancel_subscription]
    
    def index
      @current_subscription = current_workspace.tenant.current_subscription
      @billing_plans = GeneraAtende::BillingPlan.active.order(:price)
      @usage_stats = current_workspace.tenant.usage_stats
      @next_billing_date = @current_subscription&.next_billing_date
      @payment_methods = fetch_payment_methods
    end
    
    def show
      @subscription = current_workspace.tenant.subscriptions.find(params[:id])
      @invoices = fetch_invoices(@subscription)
    end
    
    def update_plan
      @new_plan = GeneraAtende::BillingPlan.find(params[:plan_id])
      @current_subscription = current_workspace.tenant.current_subscription
      
      if @current_subscription.nil?
        create_new_subscription(@new_plan)
      else
        upgrade_subscription(@new_plan)
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to genera_atende.billing_path, alert: 'Billing plan not found.'
    end
    
    def cancel_subscription
      @current_subscription = current_workspace.tenant.current_subscription
      
      if @current_subscription&.cancel!
        redirect_to genera_atende.billing_path, notice: 'Subscription cancelled successfully.'
      else
        redirect_to genera_atende.billing_path, alert: 'Unable to cancel subscription.'
      end
    end
    
    def payment_methods
      @payment_methods = fetch_payment_methods
    end
    
    def add_payment_method
      # TODO: Implement payment method addition
      # This would typically integrate with a payment processor like Stripe
      redirect_to genera_atende.billing_path, notice: 'Payment method integration coming soon.'
    end
    
    def remove_payment_method
      # TODO: Implement payment method removal
      redirect_to genera_atende.billing_path, notice: 'Payment method removal coming soon.'
    end
    
    private
    
    def ensure_admin_access
      return if @current_workspace&.admin?(current_user)
      
      redirect_to genera_atende.billing_path, alert: 'Only workspace admins can manage billing.'
    end
    
    def create_new_subscription(plan)
      subscription = current_workspace.tenant.subscriptions.build(
        billing_plan: plan,
        status: 'active',
        current_period_start: Time.current,
        current_period_end: plan.calculate_next_period_end(Time.current)
      )
      
      if subscription.save
        redirect_to genera_atende.billing_path, notice: 'Subscription created successfully.'
      else
        redirect_to genera_atende.billing_path, alert: 'Unable to create subscription.'
      end
    end
    
    def upgrade_subscription(plan)
      @current_subscription = current_workspace.tenant.current_subscription
      
      # Create a new subscription for the upgrade
      new_subscription = current_workspace.tenant.subscriptions.build(
        billing_plan: plan,
        status: 'active',
        current_period_start: @current_subscription.current_period_end,
        current_period_end: plan.calculate_next_period_end(@current_subscription.current_period_end)
      )
      
      if new_subscription.save
        # Cancel the old subscription at the end of the current period
        @current_subscription.update!(
          status: 'cancelled',
          cancelled_at: Time.current
        )
        
        redirect_to genera_atende.billing_path, notice: 'Plan upgraded successfully.'
      else
        redirect_to genera_atende.billing_path, alert: 'Unable to upgrade plan.'
      end
    end
    
    def fetch_payment_methods
      # TODO: Implement actual payment method fetching
      # This would typically integrate with a payment processor
      []
    end
    
    def fetch_invoices(subscription)
      # TODO: Implement actual invoice fetching
      # This would typically query an invoices table or payment processor
      []
    end
  end
end
