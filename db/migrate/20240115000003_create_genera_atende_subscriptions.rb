# frozen_string_literal: true

class CreateGeneraAtendeSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :genera_atende_subscriptions do |t|
      t.references :tenant, null: false, foreign_key: { to_table: :genera_atende_tenants }
      t.references :billing_plan, null: false, foreign_key: { to_table: :genera_atende_billing_plans }
      
      t.string :status, null: false, default: 'active', limit: 20
      t.timestamp :current_period_start, null: false
      t.timestamp :current_period_end, null: false
      t.timestamp :cancelled_at
      t.timestamp :suspended_at
      
      # Stripe/Payment processor fields
      t.string :stripe_subscription_id, limit: 255
      t.string :stripe_customer_id, limit: 255
      t.string :payment_method_id, limit: 255

      t.timestamps
    end

    # Garantir idempotência em execuções repetidas
    add_index :genera_atende_subscriptions, :tenant_id unless index_exists?(:genera_atende_subscriptions, :tenant_id)
    add_index :genera_atende_subscriptions, :billing_plan_id unless index_exists?(:genera_atende_subscriptions, :billing_plan_id)
    add_index :genera_atende_subscriptions, :status unless index_exists?(:genera_atende_subscriptions, :status)
    add_index :genera_atende_subscriptions, :stripe_subscription_id, unique: true unless index_exists?(:genera_atende_subscriptions, :stripe_subscription_id)
    add_index :genera_atende_subscriptions, :stripe_customer_id unless index_exists?(:genera_atende_subscriptions, :stripe_customer_id)
  end
end
