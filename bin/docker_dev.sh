#!/bin/bash

# Genera Atende SaaS Docker Development Script
echo "🐳 Managing Genera Atende SaaS development containers..."

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: docker-compose is not installed"
    echo "   Install with: sudo apt install docker-compose"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Error: Docker is not running"
    echo "   Start Docker with: sudo systemctl start docker"
    exit 1
fi

# Function to start containers
start_containers() {
    echo "🚀 Starting development containers..."
    docker-compose -f docker-compose.dev.yml up -d
    
    echo "⏳ Waiting for PostgreSQL to be ready..."
    sleep 10
    
    # Check if PostgreSQL is ready
    until docker exec genera_atende_postgres pg_isready -U postgres; do
        echo "   Waiting for PostgreSQL..."
        sleep 2
    done
    
    echo "✅ Containers started successfully!"
    echo ""
    echo "📊 Container status:"
    docker-compose -f docker-compose.dev.yml ps
}

# Function to stop containers
stop_containers() {
    echo "🛑 Stopping development containers..."
    docker-compose -f docker-compose.dev.yml down
    echo "✅ Containers stopped!"
}

# Function to restart containers
restart_containers() {
    echo "🔄 Restarting development containers..."
    docker-compose -f docker-compose.dev.yml restart
    echo "✅ Containers restarted!"
}

# Function to show logs
show_logs() {
    echo "📋 Showing container logs..."
    docker-compose -f docker-compose.dev.yml logs -f
}

# Function to show status
show_status() {
    echo "📊 Container status:"
    docker-compose -f docker-compose.dev.yml ps
}

# Function to clean up
cleanup() {
    echo "🧹 Cleaning up containers and volumes..."
    docker-compose -f docker-compose.dev.yml down -v
    docker system prune -f
    echo "✅ Cleanup completed!"
}

# Main script logic
case "${1:-start}" in
    start)
        start_containers
        ;;
    stop)
        stop_containers
        ;;
    restart)
        restart_containers
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    cleanup)
        cleanup
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|logs|status|cleanup}"
        echo ""
        echo "Commands:"
        echo "  start   - Start development containers"
        echo "  stop    - Stop development containers"
        echo "  restart - Restart development containers"
        echo "  logs    - Show container logs"
        echo "  status  - Show container status"
        echo "  cleanup - Clean up containers and volumes"
        exit 1
        ;;
esac
