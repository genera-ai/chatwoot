# frozen_string_literal: true

# == Schema Information
#
# Table name: genera_atende_billing_plans
#
#  id                    :bigint           not null, primary key
#  agent_limit           :integer          default(0), not null
#  agent_overage_price   :decimal(10, 2)   default(5.0)
#  description           :text             not null
#  featured              :boolean          default(FALSE)
#  features              :json
#  interval              :string(20)       not null
#  message_limit         :integer          default(0), not null
#  message_overage_price :decimal(10, 4)   default(0.01)
#  name                  :string(255)      not null
#  price                 :decimal(10, 2)   not null
#  status                :string(20)       default("active"), not null
#  storage_limit         :integer          default(0), not null
#  storage_overage_price :decimal(10, 2)   default(0.1)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_genera_atende_billing_plans_on_featured  (featured)
#  index_genera_atende_billing_plans_on_name      (name) UNIQUE
#  index_genera_atende_billing_plans_on_status    (status)
#
module GeneraAtende
  class BillingPlan < ApplicationRecord
    self.table_name = 'genera_atende_billing_plans'
    
    # Associations
    has_many :subscriptions, class_name: 'GeneraAtende::Subscription', dependent: :restrict_with_error
    
    # Validations
    validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :description, presence: true, length: { maximum: 1000 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :interval, presence: true, inclusion: { in: %w[monthly yearly] }
    validates :status, presence: true, inclusion: { in: %w[active inactive] }
    validates :message_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :agent_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :storage_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    # Scopes
    scope :active, -> { where(status: 'active') }
    scope :inactive, -> { where(status: 'inactive') }
    scope :monthly, -> { where(interval: 'monthly') }
    scope :yearly, -> { where(interval: 'yearly') }
    scope :featured, -> { where(featured: true) }
    
    # Callbacks
    before_validation :set_defaults, on: :create
    
    # Instance methods
    def active?
      status == 'active'
    end
    
    def inactive?
      status == 'inactive'
    end
    
    def monthly?
      interval == 'monthly'
    end
    
    def yearly?
      interval == 'yearly'
    end
    
    def price_per_month
      return price if monthly?
      
      price / 12.0
    end
    
    def yearly_discount_percentage
      return 0 if monthly?
      
      monthly_equivalent = price_per_month * 12
      ((monthly_equivalent - price) / monthly_equivalent * 100).round(1)
    end
    
    def calculate_next_period_end(start_date)
      case interval
      when 'monthly'
        start_date + 1.month
      when 'yearly'
        start_date + 1.year
      else
        start_date + 1.month
      end
    end
    
    def features_list
      features.present? ? JSON.parse(features) : []
    rescue JSON::ParserError
      []
    end
    
    def features_list=(features_array)
      self.features = features_array.to_json
    end
    
    def has_feature?(feature_name)
      features_list.include?(feature_name)
    end
    
    def add_feature(feature_name)
      current_features = features_list
      current_features << feature_name unless current_features.include?(feature_name)
      self.features_list = current_features
    end
    
    def remove_feature(feature_name)
      current_features = features_list
      current_features.delete(feature_name)
      self.features_list = current_features
    end
    
    def usage_stats_for_tenant(tenant)
      tenant_usage = tenant.usage_stats
      
      {
        messages: {
          used: tenant_usage[:messages],
          limit: message_limit,
          percentage: (tenant_usage[:messages].to_f / message_limit * 100).round(1)
        },
        agents: {
          used: tenant_usage[:agents],
          limit: agent_limit,
          percentage: (tenant_usage[:agents].to_f / agent_limit * 100).round(1)
        },
        storage: {
          used: tenant_usage[:storage],
          limit: storage_limit,
          percentage: (tenant_usage[:storage].to_f / storage_limit * 100).round(1)
        }
      }
    end
    
    def overage_calculation_for_tenant(tenant)
      tenant_usage = tenant.usage_stats
      overage = {}
      
      if tenant_usage[:messages] > message_limit
        overage[:messages] = {
          amount: tenant_usage[:messages] - message_limit,
          cost: (tenant_usage[:messages] - message_limit) * message_overage_price
        }
      end
      
      if tenant_usage[:agents] > agent_limit
        overage[:agents] = {
          amount: tenant_usage[:agents] - agent_limit,
          cost: (tenant_usage[:agents] - agent_limit) * agent_overage_price
        }
      end
      
      if tenant_usage[:storage] > storage_limit
        overage[:storage] = {
          amount: tenant_usage[:storage] - storage_limit,
          cost: (tenant_usage[:storage] - storage_limit) * storage_overage_price
        }
      end
      
      overage
    end
    
    # Class methods
    def self.default_plan
      find_by(name: 'Free') || active.first
    end
    
    def self.popular_plans
      active.featured.order(:price)
    end
    
    def self.create_default_plans!
      return if exists?
      
      # Free Plan
      create!(
        name: 'Free',
        description: 'Perfect for getting started',
        price: 0,
        interval: 'monthly',
        message_limit: 1000,
        agent_limit: 2,
        storage_limit: 1,
        message_overage_price: 0.01,
        agent_overage_price: 5.00,
        storage_overage_price: 0.10,
        features: ['Basic Support', 'Email Integration'].to_json,
        status: 'active',
        featured: false
      )
      
      # Professional Plan
      create!(
        name: 'Professional',
        description: 'Perfect for growing businesses',
        price: 29,
        interval: 'monthly',
        message_limit: 10000,
        agent_limit: 5,
        storage_limit: 10,
        message_overage_price: 0.005,
        agent_overage_price: 3.00,
        storage_overage_price: 0.05,
        features: ['Priority Support', 'Email Integration', 'WhatsApp Integration', 'Analytics'].to_json,
        status: 'active',
        featured: true
      )
      
      # Enterprise Plan
      create!(
        name: 'Enterprise',
        description: 'For large organizations',
        price: 99,
        interval: 'monthly',
        message_limit: 100000,
        agent_limit: 25,
        storage_limit: 100,
        message_overage_price: 0.001,
        agent_overage_price: 2.00,
        storage_overage_price: 0.02,
        features: ['24/7 Support', 'All Integrations', 'Advanced Analytics', 'Custom Domain', 'SSO'].to_json,
        status: 'active',
        featured: true
      )
    end
    
    private
    
    def set_defaults
      self.status ||= 'active'
      self.message_overage_price ||= 0.01
      self.agent_overage_price ||= 5.00
      self.storage_overage_price ||= 0.10
      self.features ||= [].to_json
    end
  end
end
