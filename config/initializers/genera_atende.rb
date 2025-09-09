# frozen_string_literal: true

# Genera Atende SaaS Configuration Initializer
module GeneraAtende
  class Configuration
    attr_accessor :config_data
    
    def initialize
      @config_data = load_config
    end
    
    def [](key)
      @config_data.dig(*key.to_s.split('.'))
    end
    
    def method_missing(method_name, *args, &block)
      if @config_data.key?(method_name.to_s)
        value = @config_data[method_name.to_s]
        value.is_a?(Hash) ? OpenStruct.new(value) : value
      else
        super
      end
    end
    
    def respond_to_missing?(method_name, include_private = false)
      @config_data.key?(method_name.to_s) || super
    end
    
    private
    
    def load_config
      config_file = Rails.root.join('config', 'genera_atende.yml')
      
      if File.exist?(config_file)
        YAML.load_file(config_file)[Rails.env] || YAML.load_file(config_file)['genera_atende']
      else
        default_config
      end
    rescue => e
      Rails.logger.error "Error loading Genera Atende config: #{e.message}"
      default_config
    end
    
    def default_config
      {
        'branding' => {
          'company_name' => 'Genera Atende',
          'logo_url' => '/genera-logo.png',
          'primary_color' => '#3B82F6'
        },
        'features' => {
          'billing_enabled' => true,
          'multitenancy_enabled' => true,
          'custom_domain_enabled' => true
        }
      }
    end
  end
  
  # Global configuration instance
  Config = Configuration.new
  
  # Helper methods for easy access
  def self.config
    Config
  end
  
  def self.feature_enabled?(feature)
    Config.features.send("#{feature}?") rescue false
  end
  
  def self.branding
    Config.branding
  end
  
  def self.billing
    Config.billing
  end
  
  def self.multitenancy
    Config.multitenancy
  end
  
  def self.security
    Config.security
  end
  
  def self.integrations
    Config.integrations
  end
  
  def self.analytics
    Config.analytics
  end
  
  def self.notifications
    Config.notifications
  end
end

# Make configuration available in views and controllers
Rails.application.configure do
  config.genera_atende = GeneraAtende::Config
end

# Add helper methods to ApplicationController
# This will be loaded after ApplicationController is defined
Rails.application.config.after_initialize do
  ApplicationController.class_eval do
    helper_method :genera_atende_config, :feature_enabled?

    def genera_atende_config
      GeneraAtende::Config
    end

    def feature_enabled?(feature)
      GeneraAtende.feature_enabled?(feature)
    end
  end
end

# Add helper methods to views
ActionView::Base.class_eval do
  def genera_atende_config
    GeneraAtende::Config
  end
  
  def feature_enabled?(feature)
    GeneraAtende.feature_enabled?(feature)
  end
end

# Log configuration on startup
Rails.logger.info "Genera Atende SaaS initialized with configuration:"
Rails.logger.info "  - Billing enabled: #{GeneraAtende.feature_enabled?('billing_enabled')}"
Rails.logger.info "  - Multitenancy enabled: #{GeneraAtende.feature_enabled?('multitenancy_enabled')}"
Rails.logger.info "  - Custom domains enabled: #{GeneraAtende.feature_enabled?('custom_domain_enabled')}"
Rails.logger.info "  - Company: #{GeneraAtende.branding.company_name}"
Rails.logger.info "  - Primary color: #{GeneraAtende.branding.primary_color}"
