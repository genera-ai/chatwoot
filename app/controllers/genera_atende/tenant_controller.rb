# frozen_string_literal: true

module GeneraAtende
  class TenantController < GeneraAtende::ApplicationController
    before_action :ensure_admin_access
    
    def settings
      @tenant = current_workspace.tenant
      @workspace = current_workspace
      @current_plan = @tenant.billing_plan
      @usage_stats = @tenant.usage_stats
    end
    
    def update_settings
      @tenant = current_workspace.tenant
      @workspace = current_workspace
      
      if update_tenant_settings && update_workspace_settings
        redirect_to genera_atende.settings_path, notice: 'Settings updated successfully.'
      else
        render :settings, status: :unprocessable_entity
      end
    end
    
    def branding
      @workspace = current_workspace
      @branding_settings = @workspace.branding_settings
    end
    
    def update_branding
      @workspace = current_workspace
      
      if @workspace.update_branding(
        logo_url: params[:logo_url],
        primary_color: params[:primary_color],
        company_name: params[:company_name]
      )
        redirect_to genera_atende.branding_path, notice: 'Branding updated successfully.'
      else
        render :branding, status: :unprocessable_entity
      end
    end
    
    def security
      @workspace = current_workspace
      @tenant = current_workspace.tenant
    end
    
    def enable_2fa
      # TODO: Implement 2FA enablement
      redirect_to genera_atende.security_path, notice: 'Two-factor authentication setup coming soon.'
    end
    
    def manage_api_keys
      # TODO: Implement API key management
      redirect_to genera_atende.security_path, notice: 'API key management coming soon.'
    end
    
    private
    
    def update_tenant_settings
      tenant_params = params.require(:tenant).permit(:name, :domain, :description)
      @tenant.update(tenant_params)
    end
    
    def update_workspace_settings
      workspace_params = params.require(:workspace).permit(:name, :description)
      @workspace.update(workspace_params)
    end
  end
end
