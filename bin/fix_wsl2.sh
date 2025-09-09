#!/bin/bash

# WSL2 Quick Fix Script for Genera Atende SaaS
echo "🔧 Quick fix for WSL2 environment..."

# Check if we're in WSL2
if ! grep -q Microsoft /proc/version; then
    echo "ℹ️  Native Linux detected - using standard installation"
fi

# Update PATH to use Linux executables
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

echo "🔍 Current environment status:"
echo "   - Ruby: $(command -v ruby 2>/dev/null || echo 'Not found')"
echo "   - Node.js: $(command -v node 2>/dev/null || echo 'Not found')"
echo "   - pnpm: $(command -v pnpm 2>/dev/null || echo 'Not found')"
echo "   - Docker: $(command -v docker 2>/dev/null || echo 'Not found')"

# Install Ruby dependencies and Ruby
echo "📦 Installing Ruby..."
chmod +x bin/install_ruby_deps.sh
chmod +x bin/install_ruby.sh
./bin/install_ruby_deps.sh
./bin/install_ruby.sh

# Install pnpm
echo "📦 Installing pnpm..."
chmod +x bin/install_pnpm.sh
./bin/install_pnpm.sh

# Start Docker containers
echo "🐳 Starting Docker containers..."
chmod +x bin/docker_dev.sh
./bin/docker_dev.sh start

# Wait for containers
echo "⏳ Waiting for containers to be ready..."
sleep 10

# Copy environment file
if [ ! -f ".env" ]; then
    echo "📋 Creating .env file..."
    cp .env.development .env
fi

# Install Ruby dependencies
echo "📦 Installing Ruby dependencies..."
bundle install

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
pnpm install

# Run database migrations
echo "🗄️ Running database migrations..."
rails db:migrate

# Seed the database
echo "🌱 Seeding database..."
rails db:seed

echo "✅ WSL2 fix completed!"
echo ""
echo "🎯 Next steps:"
echo "   1. Start development: pnpm dev"
echo "   2. Access: http://localhost:3000/genera_atende/dashboard"
