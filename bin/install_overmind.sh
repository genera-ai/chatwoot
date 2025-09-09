#!/bin/bash

# Overmind Installation Script
echo "📦 Installing overmind for process management..."

# Check if overmind is already installed
if command -v overmind &> /dev/null; then
    echo "✅ overmind is already installed: $(overmind --version)"
    exit 0
fi

# Install overmind
echo "📦 Installing overmind..."
go install github.com/DarthSim/overmind/v2@latest

# If go is not installed, install it first
if ! command -v go &> /dev/null; then
    echo "📦 Installing Go first..."
    wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin
    rm go1.21.5.linux-amd64.tar.gz
fi

# Install overmind
go install github.com/DarthSim/overmind/v2@latest

# Add Go bin to PATH
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
export PATH=$PATH:$(go env GOPATH)/bin

# Verify installation
if command -v overmind &> /dev/null; then
    echo "✅ overmind installed successfully: $(overmind --version)"
else
    echo "❌ overmind installation failed"
    exit 1
fi

echo "✅ overmind installation completed!"
