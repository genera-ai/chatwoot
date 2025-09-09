# frozen_string_literal: true

# == Schema Information
#
# Table name: genera_atende_workspaces
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string(255)      not null
#  settings    :json
#  slug        :string(255)      not null
#  status      :string(20)       default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :bigint           not null
#
# Indexes
#
#  index_genera_atende_workspaces_on_status              (status)
#  index_genera_atende_workspaces_on_tenant_id           (tenant_id)
#  index_genera_atende_workspaces_on_tenant_id_and_slug  (tenant_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => genera_atende_tenants.id)
#
module GeneraAtende
  class Workspace < ApplicationRecord
    self.table_name = 'genera_atende_workspaces'
    
    # Associations
    belongs_to :tenant, class_name: 'GeneraAtende::Tenant'
    has_many :workspace_users, class_name: 'GeneraAtende::WorkspaceUser', dependent: :destroy
    has_many :users, through: :workspace_users, source: :user, class_name: 'User'
    
    # Validations
    validates :name, presence: true, length: { maximum: 255 }
    validates :slug, presence: true, uniqueness: { scope: :tenant_id }, length: { maximum: 255 }
    validates :status, presence: true, inclusion: { in: %w[active inactive suspended] }
    
    # Scopes
    scope :active, -> { where(status: 'active') }
    scope :inactive, -> { where(status: 'inactive') }
    scope :suspended, -> { where(status: 'suspended') }
    
    # Callbacks
    before_validation :generate_slug, on: :create
    before_validation :normalize_slug
    
    # Instance methods
    def active?
      status == 'active'
    end
    
    def inactive?
      status == 'inactive'
    end
    
    def suspended?
      status == 'suspended'
    end
    
    def activate!
      update!(status: 'active')
    end
    
    def deactivate!
      update!(status: 'inactive')
    end
    
    def suspend!
      update!(status: 'suspended')
    end
    
    def add_user(user, role: 'agent')
      return false if user.nil?
      
      workspace_user = workspace_users.find_or_initialize_by(user: user)
      workspace_user.role = role
      workspace_user.save!
    end
    
    def remove_user(user)
      workspace_users.find_by(user: user)&.destroy!
    end
    
    def user_role(user)
      workspace_users.find_by(user: user)&.role
    end
    
    def admin?(user)
      user_role(user) == 'admin'
    end
    
    def agent?(user)
      user_role(user) == 'agent'
    end
    
    def member?(user)
      workspace_users.exists?(user: user)
    end
    
    def admins
      users.joins(:workspace_users)
            .where(genera_atende_workspace_users: { role: 'admin' })
    end
    
    def agents
      users.joins(:workspace_users)
            .where(genera_atende_workspace_users: { role: 'agent' })
    end
    
    def member_count
      workspace_users.count
    end
    
    def admin_count
      workspace_users.where(role: 'admin').count
    end
    
    def agent_count
      workspace_users.where(role: 'agent').count
    end
    
    def settings
      return {} if settings_json.blank?
      
      JSON.parse(settings_json)
    rescue JSON::ParserError
      {}
    end
    
    def settings=(new_settings)
      self.settings_json = new_settings.to_json
    end
    
    def update_setting(key, value)
      current_settings = settings
      current_settings[key.to_s] = value
      self.settings = current_settings
    end
    
    def get_setting(key, default = nil)
      settings[key.to_s] || default
    end
    
    def custom_domain
      get_setting('custom_domain')
    end
    
    def custom_domain=(domain)
      update_setting('custom_domain', domain)
    end
    
    def branding_settings
      {
        logo_url: get_setting('logo_url'),
        primary_color: get_setting('primary_color'),
        company_name: get_setting('company_name', name)
      }
    end
    
    def update_branding(logo_url: nil, primary_color: nil, company_name: nil)
      update_setting('logo_url', logo_url) if logo_url
      update_setting('primary_color', primary_color) if primary_color
      update_setting('company_name', company_name) if company_name
    end
    
    def usage_stats
      {
        conversations: calculate_conversation_count,
        messages: calculate_message_count,
        agents: agent_count,
        admins: admin_count
      }
    end
    
    def can_add_user?
      return false unless active?
      return true unless tenant.billing_plan
      
      current_users = member_count
      current_users < tenant.billing_plan.agent_limit
    end
    
    def can_create_conversation?
      return false unless active?
      return true unless tenant.billing_plan
      
      tenant.can_send_message?
    end
    
    private
    
    def generate_slug
      return if slug.present?
      
      base_slug = name.parameterize
      self.slug = base_slug
      
      # Ensure uniqueness within tenant
      counter = 1
      while GeneraAtende::Workspace.exists?(slug: slug, tenant: tenant)
        self.slug = "#{base_slug}-#{counter}"
        counter += 1
      end
    end
    
    def normalize_slug
      return unless slug.present?
      
      self.slug = slug.parameterize
    end
    
    def calculate_conversation_count
      # TODO: Implement actual conversation counting
      # This would typically query the conversations table
      0
    end
    
    def calculate_message_count
      # TODO: Implement actual message counting
      # This would typically query the messages table
      0
    end
  end
end
