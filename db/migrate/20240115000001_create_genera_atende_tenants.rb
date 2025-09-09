# frozen_string_literal: true

class CreateGeneraAtendeTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :genera_atende_tenants do |t|
      t.string :name, null: false, limit: 255
      t.string :domain, null: false, limit: 255
      t.string :subdomain, null: false, limit: 255
      t.text :description
      t.string :status, null: false, default: 'active', limit: 20
      t.json :settings, default: {}
      t.timestamp :suspended_at
      t.timestamp :cancelled_at

      t.timestamps
    end

    add_index :genera_atende_tenants, :domain, unique: true
    add_index :genera_atende_tenants, :subdomain, unique: true
    add_index :genera_atende_tenants, :status
  end
end
