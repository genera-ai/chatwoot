# frozen_string_literal: true

# == Schema Information
#
# Table name: genera_atende_workspace_users
#
#  id             :bigint           not null, primary key
#  joined_at      :datetime         not null
#  last_active_at :datetime
#  role           :string(20)       default("agent"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#  workspace_id   :bigint           not null
#
# Indexes
#
#  index_genera_atende_workspace_users_on_last_active_at            (last_active_at)
#  index_genera_atende_workspace_users_on_role                      (role)
#  index_genera_atende_workspace_users_on_user_id                   (user_id)
#  index_genera_atende_workspace_users_on_workspace_id              (workspace_id)
#  index_genera_atende_workspace_users_on_workspace_id_and_user_id  (workspace_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (workspace_id => genera_atende_workspaces.id)
#
module GeneraAtende
  class WorkspaceUser < ApplicationRecord
    self.table_name = 'genera_atende_workspace_users'
    
    # Associations
    belongs_to :workspace, class_name: 'GeneraAtende::Workspace'
    belongs_to :user, class_name: 'User'
    
    # Validations
    validates :role, presence: true, inclusion: { in: %w[admin agent] }
    validates :joined_at, presence: true
    validates :workspace_id, uniqueness: { scope: :user_id }
    
    # Scopes
    scope :admins, -> { where(role: 'admin') }
    scope :agents, -> { where(role: 'agent') }
    scope :active, -> { where.not(last_active_at: nil) }
    
    # Callbacks
    before_validation :set_joined_at, on: :create
    before_save :update_last_active_at
    
    # Instance methods
    def admin?
      role == 'admin'
    end
    
    def agent?
      role == 'agent'
    end
    
    def active?
      last_active_at.present?
    end
    
    def mark_as_active!
      update!(last_active_at: Time.current)
    end
    
    private
    
    def set_joined_at
      self.joined_at ||= Time.current
    end
    
    def update_last_active_at
      self.last_active_at = Time.current if last_active_at.nil?
    end
  end
end
