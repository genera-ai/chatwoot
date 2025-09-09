# frozen_string_literal: true

# Genera Atende SaaS Seeds
puts "🌱 Seeding Genera Atende SaaS data..."

# Create default billing plans
puts "📋 Creating billing plans..."

GeneraAtende::BillingPlan.create_default_plans!

# Create a demo tenant
puts "🏢 Creating demo tenant..."

demo_tenant = GeneraAtende::Tenant.find_or_create_by(domain: 'demo.genera-atende.com') do |tenant|
  tenant.name = 'Demo Company'
  tenant.subdomain = 'demo'
  tenant.description = 'Demo tenant for testing Genera Atende'
  tenant.status = 'active'
end

# Create a demo workspace
puts "🏠 Creating demo workspace..."

demo_workspace = GeneraAtende::Workspace.find_or_create_by(tenant: demo_tenant, slug: 'main') do |workspace|
  workspace.name = 'Main Workspace'
  workspace.description = 'Main workspace for Demo Company'
  workspace.status = 'active'
end

# Create a subscription for the demo tenant
puts "💳 Creating demo subscription..."

free_plan = GeneraAtende::BillingPlan.find_by(name: 'Free')
if free_plan && !demo_tenant.subscriptions.exists?
  demo_tenant.subscriptions.create!(
    billing_plan: free_plan,
    status: 'active',
    current_period_start: Time.current,
    current_period_end: free_plan.calculate_next_period_end(Time.current)
  )
end

# Add current user to the demo workspace if user exists
if defined?(User) && User.any?
  puts "👤 Adding current user to demo workspace..."
  
  current_user = User.first
  if current_user && !demo_workspace.member?(current_user)
    demo_workspace.add_user(current_user, role: 'admin')
  end
end

puts "✅ Genera Atende SaaS seeding completed!"
puts "   - Tenant: #{demo_tenant.name} (#{demo_tenant.domain})"
puts "   - Workspace: #{demo_workspace.name}"
puts "   - Billing Plans: #{GeneraAtende::BillingPlan.count} created"
puts "   - Subscriptions: #{demo_tenant.subscriptions.count} created"
