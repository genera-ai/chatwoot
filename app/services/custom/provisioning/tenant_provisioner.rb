# frozen_string_literal: true

module Custom
  module Provisioning
    class TenantProvisioner
      def initialize(tenant:)
        @tenant = tenant
      end

      # Creates a default workspace and links the given user as admin
      def provision!(owner:)
        workspace = GeneraAtende::Workspace.find_or_create_by!(
          tenant: @tenant,
          slug: 'main'
        ) do |w|
          w.name = 'Main Workspace'
          w.status = 'active'
        end

        workspace.add_user(owner, role: 'admin') unless workspace.member?(owner)

        workspace
      end
    end
  end
end
