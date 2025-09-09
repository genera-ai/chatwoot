# frozen_string_literal: true

# == Schema Information
#
# Table name: genera_atende_subscriptions
#
#  id                     :bigint           not null, primary key
#  cancelled_at           :datetime
#  current_period_end     :datetime         not null
#  current_period_start   :datetime         not null
#  status                 :string(20)       default("active"), not null
#  suspended_at           :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  billing_plan_id        :bigint           not null
#  payment_method_id      :string(255)
#  stripe_customer_id     :string(255)
#  stripe_subscription_id :string(255)
#  tenant_id              :bigint           not null
#
# Indexes
#
#  index_genera_atende_subscriptions_on_billing_plan_id         (billing_plan_id)
#  index_genera_atende_subscriptions_on_status                  (status)
#  index_genera_atende_subscriptions_on_stripe_customer_id      (stripe_customer_id)
#  index_genera_atende_subscriptions_on_stripe_subscription_id  (stripe_subscription_id) UNIQUE
#  index_genera_atende_subscriptions_on_tenant_id               (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (billing_plan_id => genera_atende_billing_plans.id)
#  fk_rails_...  (tenant_id => genera_atende_tenants.id)
#
module GeneraAtende
  class Subscription < ApplicationRecord
    self.table_name = 'genera_atende_subscriptions'
    
    # Associations
    belongs_to :tenant, class_name: 'GeneraAtende::Tenant'
    belongs_to :billing_plan, class_name: 'GeneraAtende::BillingPlan'
    
    # Validations
    validates :status, presence: true, inclusion: { in: %w[active cancelled suspended past_due] }
    validates :current_period_start, presence: true
    validates :current_period_end, presence: true
    validate :period_end_after_start
    
    # Scopes
    scope :active, -> { where(status: 'active') }
    scope :cancelled, -> { where(status: 'cancelled') }
    scope :suspended, -> { where(status: 'suspended') }
    scope :past_due, -> { where(status: 'past_due') }
    
    # Callbacks
    before_validation :set_defaults, on: :create
    
    # Instance methods
    def active?
      status == 'active'
    end
    
    def cancelled?
      status == 'cancelled'
    end
    
    def suspended?
      status == 'suspended'
    end
    
    def past_due?
      status == 'past_due'
    end
    
    def expired?
      current_period_end < Time.current
    end
    
    def days_until_renewal
      return 0 if expired?
      
      (current_period_end - Time.current).to_i / 1.day
    end
    
    def next_billing_date
      current_period_end
    end
    
    def cancel!
      update!(status: 'cancelled', cancelled_at: Time.current)
    end
    
    def suspend!
      update!(status: 'suspended', suspended_at: Time.current)
    end
    
    def reactivate!
      update!(status: 'active', suspended_at: nil)
    end
    
    def renew!
      return false if active?
      
      new_start = current_period_end
      new_end = billing_plan.calculate_next_period_end(new_start)
      
      update!(
        current_period_start: new_start,
        current_period_end: new_end,
        status: 'active'
      )
    end
    
    def usage_within_limits?
      return true unless billing_plan
      
      tenant_usage = tenant.usage_stats
      
      tenant_usage[:messages] <= billing_plan.message_limit &&
        tenant_usage[:agents] <= billing_plan.agent_limit &&
        tenant_usage[:storage] <= billing_plan.storage_limit
    end
    
    def overage_amount
      return 0 if usage_within_limits?
      
      tenant_usage = tenant.usage_stats
      overage = 0
      
      if tenant_usage[:messages] > billing_plan.message_limit
        overage += (tenant_usage[:messages] - billing_plan.message_limit) * billing_plan.message_overage_price
      end
      
      if tenant_usage[:agents] > billing_plan.agent_limit
        overage += (tenant_usage[:agents] - billing_plan.agent_limit) * billing_plan.agent_overage_price
      end
      
      if tenant_usage[:storage] > billing_plan.storage_limit
        overage += (tenant_usage[:storage] - billing_plan.storage_limit) * billing_plan.storage_overage_price
      end
      
      overage
    end
    
    private
    
    def set_defaults
      self.status ||= 'active'
      self.current_period_start ||= Time.current
      self.current_period_end ||= billing_plan&.calculate_next_period_end(current_period_start)
    end
    
    def period_end_after_start
      return unless current_period_start && current_period_end
      
      if current_period_end <= current_period_start
        errors.add(:current_period_end, 'must be after start date')
      end
    end
  end
end
