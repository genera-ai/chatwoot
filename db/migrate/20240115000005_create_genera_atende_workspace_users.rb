# frozen_string_literal: true

class CreateGeneraAtendeWorkspaceUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :genera_atende_workspace_users do |t|
      t.references :workspace, null: false, foreign_key: { to_table: :genera_atende_workspaces }
      t.references :user, null: false, foreign_key: true
      
      t.string :role, null: false, default: 'agent', limit: 20
      t.timestamp :joined_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :last_active_at

      t.timestamps
    end

    add_index :genera_atende_workspace_users, [:workspace_id, :user_id], unique: true
    add_index :genera_atende_workspace_users, :role
    add_index :genera_atende_workspace_users, :last_active_at
  end
end
