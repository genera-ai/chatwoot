# frozen_string_literal: true

module Custom
  module Billing
    class Service
      def initialize(gateway: default_gateway)
        @gateway = gateway
      end

      def subscribe!(tenant:, plan:)
        @gateway.find_or_create_customer!(tenant: tenant)
        sub = @gateway.upsert_subscription!(tenant: tenant, plan_id: plan.external_id || plan.id)
        # Persist minimal fields on our subscription model if needed
        tenant.subscriptions.create!(
          billing_plan: plan,
          status: sub.status || 'active',
          current_period_start: Time.current,
          current_period_end: plan.calculate_next_period_end(Time.current)
        )
      end

      def cancel!(tenant:)
        @gateway.cancel_subscription!(tenant: tenant)
      end

      def payment_methods(tenant:)
        @gateway.list_payment_methods(tenant: tenant)
      end

      def add_payment_method!(tenant:, token:)
        @gateway.add_payment_method!(tenant: tenant, token: token)
      end

      def remove_payment_method!(tenant:, payment_method_id:)
        @gateway.remove_payment_method!(tenant: tenant, payment_method_id: payment_method_id)
      end

      def invoices(tenant:)
        @gateway.list_invoices(tenant: tenant)
      end

      private

      def default_gateway
        case ENV.fetch('BILLING_GATEWAY', nil)
        when 'stripe'
          StripeGateway.new
        when 'asaas'
          AsaasGateway.new
        else
          BaseGateway.new # will raise NotImplementedError if used
        end
      end
    end
  end
end
