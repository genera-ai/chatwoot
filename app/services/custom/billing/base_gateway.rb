# frozen_string_literal: true

module Custom
  module Billing
    # Base class for billing gateways.
    # Implementations must override the public methods to integrate with a payment processor.
    class BaseGateway
      def initialize(options = {})
        @options = options
      end

      # Creates or fetches a billing customer for the given tenant
      # Returns an object with at least :id
      def find_or_create_customer!(tenant:)
        raise NotImplementedError, 'find_or_create_customer! must be implemented in a subclass'
      end

      # Creates or updates a subscription for the tenant on the given plan
      # Returns an object with at least :id and :status
      def upsert_subscription!(tenant:, plan_id:)
        raise NotImplementedError, 'upsert_subscription! must be implemented in a subclass'
      end

      # Cancels the current subscription
      def cancel_subscription!(tenant:)
        raise NotImplementedError, 'cancel_subscription! must be implemented in a subclass'
      end

      # Payment methods
      def list_payment_methods(tenant:)
        raise NotImplementedError, 'list_payment_methods must be implemented in a subclass'
      end

      def add_payment_method!(tenant:, token:)
        raise NotImplementedError, 'add_payment_method! must be implemented in a subclass'
      end

      def remove_payment_method!(tenant:, payment_method_id:)
        raise NotImplementedError, 'remove_payment_method! must be implemented in a subclass'
      end

      # Invoices
      def list_invoices(tenant:)
        raise NotImplementedError, 'list_invoices must be implemented in a subclass'
      end
    end
  end
end
