#!/bin/bash

# Docker Installation Check Script for Ubuntu 22.04
echo "🔍 Checking Docker installation..."

# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
    docker --version
else
    echo "❌ Docker is not installed"
    echo ""
    echo "📦 Installing Docker on Ubuntu 22.04..."
    
    # Update package index
    sudo apt update
    
    # Install required packages
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    sudo apt update
    
    # Install Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    # Start Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    echo "✅ Docker installed successfully!"
    echo "⚠️  Please log out and log back in for group changes to take effect"
    echo "   Or run: newgrp docker"
fi

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose is installed"
    docker-compose --version
else
    echo "❌ Docker Compose is not installed"
    echo "📦 Installing Docker Compose..."
    
    # Install docker-compose
    sudo apt install -y docker-compose
    
    echo "✅ Docker Compose installed successfully!"
fi

# Check if Docker is running
if docker info &> /dev/null; then
    echo "✅ Docker is running"
else
    echo "❌ Docker is not running"
    echo "🚀 Starting Docker service..."
    sudo systemctl start docker
    echo "✅ Docker started!"
fi

echo ""
echo "🎯 Docker setup completed!"
echo "   You can now run: ./bin/docker_dev.sh start"
