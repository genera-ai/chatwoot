# frozen_string_literal: true

module Custom
  module Billing
    class StripeGateway < BaseGateway
      def find_or_create_customer!(tenant:)
        # TODO: Integrar com Stripe::Customer
        OpenStruct.new(id: tenant.stripe_customer_id || "cus_#{tenant.id}")
      end

      def upsert_subscription!(tenant:, plan_id:)
        # TODO: Integrar com Stripe::Subscription
        OpenStruct.new(id: tenant.stripe_subscription_id || "sub_#{tenant.id}", status: 'active')
      end

      def cancel_subscription!(tenant:)
        true
      end

      def list_payment_methods(tenant:)
        []
      end

      def add_payment_method!(tenant:, token:)
        OpenStruct.new(id: "pm_#{SecureRandom.hex(4)}")
      end

      def remove_payment_method!(tenant:, payment_method_id:)
        true
      end

      def list_invoices(tenant:)
        []
      end
    end
  end
end
