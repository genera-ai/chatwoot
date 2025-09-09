# frozen_string_literal: true

module GeneraAtende
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :set_current_workspace
    before_action :ensure_workspace_access

    # Development-only: allow accessing pages without session auth
    if Rails.env.development?
      skip_before_action :authenticate_user!
      skip_before_action :ensure_workspace_access
      before_action :set_dev_workspace
    end

    private

    def set_current_workspace
      @current_workspace = current_user&.current_workspace
    end

    def set_dev_workspace
      @current_workspace ||= GeneraAtende::Workspace.first
    end

    def ensure_workspace_access
      return if @current_workspace&.member?(current_user)

      redirect_to genera_atende_dashboard_path, alert: 'You do not have access to this workspace.'
    end

    attr_reader :current_workspace

    def current_tenant
      @current_workspace&.tenant
    end

    def ensure_admin_access
      return if @current_workspace&.admin?(current_user)

      redirect_to genera_atende_dashboard_path, alert: 'Only workspace admins can access this feature.'
    end
  end
end
