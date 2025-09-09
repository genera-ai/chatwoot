# frozen_string_literal: true

module GeneraAtende
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :set_current_workspace
    before_action :ensure_workspace_access
    
    private
    
    def set_current_workspace
      @current_workspace = current_user&.current_workspace
    end
    
    def ensure_workspace_access
      return if @current_workspace&.member?(current_user)
      
      redirect_to genera_atende.dashboard_path, alert: 'You do not have access to this workspace.'
    end
    
    def current_workspace
      @current_workspace
    end
    
    def current_tenant
      @current_workspace&.tenant
    end
    
    def ensure_admin_access
      return if @current_workspace&.admin?(current_user)
      
      redirect_to genera_atende.dashboard_path, alert: 'Only workspace admins can access this feature.'
    end
  end
end
