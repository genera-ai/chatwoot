# frozen_string_literal: true

# Configure default billing gateway via ENV
# ENV['BILLING_GATEWAY'] can be 'stripe' (default: none)

Rails.logger.info("[CustomServices] Billing gateway: #{ENV['BILLING_GATEWAY'] || 'unset'}")
