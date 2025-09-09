# frozen_string_literal: true

module GeneraAtende
  class DashboardController < GeneraAtende::ApplicationController
    layout 'genera_atende'

    def index
      @stats = {
        total_conversations: current_workspace.usage_stats[:conversations],
        resolved_today: calculate_resolved_today,
        avg_response_time: calculate_avg_response_time,
        active_agents: current_workspace.agent_count
      }

      @recent_conversations = fetch_recent_conversations
      @quick_actions = build_quick_actions
    end

    private

    def calculate_resolved_today
      # TODO: Implement actual calculation based on conversations resolved today
      # This would typically query the conversations table with resolved_at date filter
      rand(50..150)
    end

    def calculate_avg_response_time
      # TODO: Implement actual calculation based on message response times
      # This would typically calculate the average time between customer messages and agent responses
      "#{rand(1..5)}.#{rand(0..9)} min"
    end

    def fetch_recent_conversations
      # TODO: Implement actual conversation fetching
      # This would typically query the conversations table with recent activity
      []
    end

    def build_quick_actions
      [
        {
          title: 'Start New Conversation',
          description: 'Begin a new customer conversation',
          icon: 'plus',
          path: '#',
          color: 'genera-primary'
        },
        {
          title: 'Configure Settings',
          description: 'Manage workspace settings',
          icon: 'cog',
          path: genera_atende_settings_path,
          color: 'gray'
        },
        {
          title: 'View Billing',
          description: 'Manage subscription and billing',
          icon: 'credit-card',
          path: genera_atende_billing_path,
          color: 'gray'
        }
      ]
    end
  end
end
