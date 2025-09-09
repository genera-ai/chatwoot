# frozen_string_literal: true

# == Schema Information
#
# Table name: genera_atende_tenants
#
#  id           :bigint           not null, primary key
#  cancelled_at :datetime
#  description  :text
#  domain       :string(255)      not null
#  name         :string(255)      not null
#  settings     :json
#  status       :string(20)       default("active"), not null
#  subdomain    :string(255)      not null
#  suspended_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_genera_atende_tenants_on_domain     (domain) UNIQUE
#  index_genera_atende_tenants_on_status     (status)
#  index_genera_atende_tenants_on_subdomain  (subdomain) UNIQUE
#
module GeneraAtende
  class Tenant < ApplicationRecord
    self.table_name = 'genera_atende_tenants'
    
    # Associations
    has_many :subscriptions, class_name: 'GeneraAtende::Subscription', dependent: :destroy
    has_many :workspaces, class_name: 'GeneraAtende::Workspace', dependent: :destroy
    has_many :users, through: :workspaces
    
    # Validations
    validates :name, presence: true, length: { maximum: 255 }
    validates :domain, presence: true, uniqueness: true, length: { maximum: 255 }
    validates :status, presence: true, inclusion: { in: %w[active suspended cancelled] }
    
    # Scopes
    scope :active, -> { where(status: 'active') }
    scope :suspended, -> { where(status: 'suspended') }
    scope :cancelled, -> { where(status: 'cancelled') }
    
    # Callbacks
    before_validation :generate_subdomain, on: :create
    before_validation :normalize_domain
    
    # Instance methods
    def active?
      status == 'active'
    end
    
    def suspended?
      status == 'suspended'
    end
    
    def cancelled?
      status == 'cancelled'
    end
    
    def current_subscription
      subscriptions.active.first
    end
    
    def billing_plan
      current_subscription&.billing_plan
    end
    
    def usage_stats
      {
        messages: calculate_message_usage,
        agents: workspaces.joins(:users).count,
        storage: calculate_storage_usage
      }
    end
    
    def can_add_agent?
      return false unless active?
      return true unless billing_plan
      
      current_agents = workspaces.joins(:users).count
      current_agents < billing_plan.agent_limit
    end
    
    def can_send_message?
      return false unless active?
      return true unless billing_plan
      
      current_messages = calculate_message_usage
      current_messages < billing_plan.message_limit
    end
    
    private
    
    def generate_subdomain
      return if subdomain.present?
      
      base_subdomain = name.parameterize
      self.subdomain = base_subdomain
      
      # Ensure uniqueness
      counter = 1
      while GeneraAtende::Tenant.exists?(subdomain: subdomain)
        self.subdomain = "#{base_subdomain}-#{counter}"
        counter += 1
      end
    end
    
    def normalize_domain
      return unless domain.present?
      
      self.domain = domain.downcase.strip
      self.domain = "https://#{domain}" unless domain.start_with?('http')
    end
    
    def calculate_message_usage
      # TODO: Implement actual message counting logic
      # This would typically query the conversations table
      0
    end
    
    def calculate_storage_usage
      # TODO: Implement actual storage calculation
      # This would typically calculate file sizes
      0
    end
  end
end
