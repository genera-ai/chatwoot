# frozen_string_literal: true

require 'faraday'
require 'json'

module Custom
  module Billing
    # Minimal Asaas gateway implementation
    # Docs (resumo):
    # - Base URL prod: https://api.asaas.com/v3
    # - Base URL sandbox: https://sandbox.asaas.com/api/v3
    # - Auth: Header 'access_token: <API_KEY>'
    # - Customers: GET /customers?email=, POST /customers
    # - Subscriptions: POST /subscriptions, POST /subscriptions/{id}/cancel
    # - Invoices: GET /subscriptions/{id}/invoices (ou /payments?subscription={id})
    class AsaasGateway < BaseGateway
      def initialize(options = {})
        super
        @api_key = ENV.fetch('ASAAS_API_KEY')
        @base_url = ENV.fetch('ASAAS_BASE_URL', default_base_url)
        @conn = Faraday.new(url: @base_url) do |f|
          f.request :json
          f.response :json, content_type: /json/
          f.adapter Faraday.default_adapter
        end
      end

      def find_or_create_customer!(tenant:)
        email = tenant.try(:email) || tenant.try(:owner)&.email
        raise ArgumentError, 'tenant email required' unless email

        customer = find_customer_by_email(email)
        return customer if customer

        payload = {
          name: tenant.name || tenant.subdomain,
          email: email,
          cpfCnpj: tenant.try(:document),
          phone: tenant.try(:phone)
        }.compact

        res = post('/customers', payload)
        OpenStruct.new(id: res.fetch('id'))
      end

      def upsert_subscription!(tenant:, plan_id:)
        customer = find_or_create_customer!(tenant: tenant)
        value = plan_value(plan_id)
        payload = {
          customer: customer.id,
          billingType: 'CREDIT_CARD',
          cycle: 'MONTHLY',
          value: value,
          description: "Subscription #{plan_id}"
        }
        res = post('/subscriptions', payload)
        OpenStruct.new(id: res.fetch('id'), status: res['status'] || 'active')
      end

      def cancel_subscription!(tenant:)
        sub_id = tenant.try(:stripe_subscription_id) || current_subscription_external_id(tenant)
        return true unless sub_id

        post("/subscriptions/#{sub_id}/cancel", {})
        true
      end

      def list_payment_methods(tenant:)
        [] # Asaas lida diretamente via cartão cadastrado no customer; manter vazio por ora
      end

      def add_payment_method!(tenant:, token:)
        # Fora do escopo mínimo; tokenização varia conforme PCI. Retornar stub.
        OpenStruct.new(id: token)
      end

      def remove_payment_method!(tenant:, payment_method_id:)
        true
      end

      def list_invoices(tenant:)
        sub_id = current_subscription_external_id(tenant)
        return [] unless sub_id

        res = get('/payments', { subscription: sub_id })
        (res['data'] || []).map { |p| OpenStruct.new(id: p['id'], status: p['status'], value: p['value']) }
      end

      private

      def default_base_url
        ENV['ASAAS_ENV'] == 'sandbox' ? 'https://sandbox.asaas.com/api/v3' : 'https://api.asaas.com/v3'
      end

      def plan_value(plan_id)
        plan = GeneraAtende::BillingPlan.find_by(id: plan_id) || GeneraAtende::BillingPlan.find_by(name: plan_id)
        (plan&.price || 0).to_f
      end

      def current_subscription_external_id(tenant)
        tenant.try(:stripe_subscription_id)
      end

      def headers
        { 'access_token' => @api_key }
      end

      def get(path, params = {})
        response = @conn.get(path, params, headers)
        raise_api_error!(response) unless response.success?
        response.body
      end

      def post(path, body)
        response = @conn.post(path, body.to_json, headers.merge('Content-Type' => 'application/json'))
        raise_api_error!(response) unless response.success?
        response.body
      end

      def raise_api_error!(response)
        msg = "Asaas API error: #{response.status} - #{response.body.inspect}"
        raise(StandardError, msg)
      end
    end
  end
end
