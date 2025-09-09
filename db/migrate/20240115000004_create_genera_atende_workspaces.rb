# frozen_string_literal: true

class CreateGeneraAtendeWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :genera_atende_workspaces do |t|
      t.references :tenant, null: false, foreign_key: { to_table: :genera_atende_tenants }
      
      t.string :name, null: false, limit: 255
      t.string :slug, null: false, limit: 255
      t.text :description
      t.string :status, null: false, default: 'active', limit: 20
      t.json :settings, default: {}

      t.timestamps
    end

    add_index :genera_atende_workspaces, [:tenant_id, :slug], unique: true
    add_index :genera_atende_workspaces, :status
  end
end
