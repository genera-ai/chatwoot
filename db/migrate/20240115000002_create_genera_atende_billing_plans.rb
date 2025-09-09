# frozen_string_literal: true

class CreateGeneraAtendeBillingPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :genera_atende_billing_plans do |t|
      t.string :name, null: false, limit: 255
      t.text :description, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.string :interval, null: false, limit: 20
      t.string :status, null: false, default: 'active', limit: 20
      t.boolean :featured, default: false
      
      # Limits
      t.integer :message_limit, null: false, default: 0
      t.integer :agent_limit, null: false, default: 0
      t.integer :storage_limit, null: false, default: 0
      
      # Overage prices
      t.decimal :message_overage_price, precision: 10, scale: 4, default: 0.01
      t.decimal :agent_overage_price, precision: 10, scale: 2, default: 5.00
      t.decimal :storage_overage_price, precision: 10, scale: 2, default: 0.10
      
      # Features
      t.json :features, default: []

      t.timestamps
    end

    add_index :genera_atende_billing_plans, :name, unique: true
    add_index :genera_atende_billing_plans, :status
    add_index :genera_atende_billing_plans, :featured
  end
end
