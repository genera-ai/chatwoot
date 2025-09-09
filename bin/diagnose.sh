#!/bin/bash

# Genera Atende SaaS Diagnostic Script
echo "🔍 Diagnosing Genera Atende SaaS environment..."

# Check WSL2
echo ""
echo "🔍 WSL2 Environment:"
if grep -q Microsoft /proc/version; then
    echo "✅ WSL2 detected"
    WSL_VERSION=$(grep -oP 'Microsoft.*WSL \K[0-9]+' /proc/version)
    echo "   WSL Version: $WSL_VERSION"
else
    echo "ℹ️  Native Linux detected"
fi

# Check Ruby
echo ""
echo "🔍 Ruby Environment:"
if command -v ruby &> /dev/null; then
    echo "✅ Ruby installed: $(ruby --version)"
    echo "   Path: $(which ruby)"
    echo "   Gem path: $(gem env home)"
else
    echo "❌ Ruby not found"
fi

# Check Node.js
echo ""
echo "🔍 Node.js Environment:"
if command -v node &> /dev/null; then
    echo "✅ Node.js installed: $(node --version)"
    echo "   Path: $(which node)"
    echo "   NPM path: $(which npm)"
else
    echo "❌ Node.js not found"
fi

# Check pnpm
echo ""
echo "🔍 pnpm Environment:"
if command -v pnpm &> /dev/null; then
    echo "✅ pnpm installed: $(pnpm --version)"
    echo "   Path: $(which pnpm)"
else
    echo "❌ pnpm not found"
fi

# Check Bundler
echo ""
echo "🔍 Bundler Environment:"
if command -v bundle &> /dev/null; then
    echo "✅ Bundler installed: $(bundle --version)"
    echo "   Path: $(which bundle)"
else
    echo "❌ Bundler not found"
fi

# Check Docker
echo ""
echo "🔍 Docker Environment:"
if command -v docker &> /dev/null; then
    echo "✅ Docker installed: $(docker --version)"
    echo "   Path: $(which docker)"
    if docker info &> /dev/null; then
        echo "✅ Docker is running"
    else
        echo "❌ Docker is not running"
    fi
else
    echo "❌ Docker not found"
fi

# Check project files
echo ""
echo "🔍 Project Files:"
if [ -f "Gemfile" ]; then
    echo "✅ Gemfile found"
else
    echo "❌ Gemfile not found"
fi

if [ -f "package.json" ]; then
    echo "✅ package.json found"
else
    echo "❌ package.json not found"
fi

if [ -f "docker-compose.dev.yml" ]; then
    echo "✅ docker-compose.dev.yml found"
else
    echo "❌ docker-compose.dev.yml not found"
fi

# Check environment variables
echo ""
echo "🔍 Environment Variables:"
echo "   PATH: $PATH"
echo "   HOME: $HOME"
echo "   USER: $USER"
echo "   SHELL: $SHELL"

# Check Docker containers
echo ""
echo "🔍 Docker Containers:"
if command -v docker &> /dev/null && docker info &> /dev/null; then
    echo "📊 Container status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
    echo "❌ Docker not available"
fi

# Check ports
echo ""
echo "🔍 Port Availability:"
if command -v lsof &> /dev/null; then
    echo "   Port 3000: $(lsof -i :3000 2>/dev/null | wc -l) processes"
    echo "   Port 5432: $(lsof -i :5432 2>/dev/null | wc -l) processes"
    echo "   Port 6379: $(lsof -i :6379 2>/dev/null | wc -l) processes"
else
    echo "   lsof not available for port checking"
fi

echo ""
echo "🎯 Diagnostic completed!"
echo ""
echo "📋 Recommendations:"
if ! command -v ruby &> /dev/null; then
    echo "   - Install Ruby: ./bin/install_system_deps.sh"
fi
if ! command -v node &> /dev/null; then
    echo "   - Install Node.js: ./bin/install_system_deps.sh"
fi
if ! command -v docker &> /dev/null; then
    echo "   - Install Docker: ./bin/check_docker.sh"
fi
if ! docker info &> /dev/null; then
    echo "   - Start Docker: sudo systemctl start docker"
fi
