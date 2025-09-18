require 'rails_helper'

RSpec.describe 'SuperAdmin::BillingPlanConfigurations', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/edit'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/super_admin/billing_plan_configurations/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
