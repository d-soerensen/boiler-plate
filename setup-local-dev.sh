#!/bin/bash

# IntelliFinder V4 Local Development Setup Script
# This script sets up the development environment using Traefik reverse proxy
# No host file modifications required!

echo "🚀 Setting up IntelliFinder V4 local development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose > /dev/null 2>&1; then
    echo "❌ Docker Compose is not available. Please install Docker Compose and try again."
    exit 1
fi

echo "✅ Docker and Docker Compose are available"

# Create the Docker network if it doesn't exist
echo "🌐 Creating Docker network..."
if ! docker network ls | grep -q "intellifinder-network"; then
    docker network create intellifinder-network
    echo "✅ Created intellifinder-network"
else
    echo "✅ intellifinder-network already exists"
fi

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found. Please run this script from the platform root directory."
    exit 1
fi

echo "✅ Docker Compose files found"

# Build the services
echo "🔨 Building services..."
docker compose build

echo ""
echo "🎉 Setup complete! You can now start the services with:"
echo ""
echo "  make dev"
echo ""
echo "📊 Service URLs (via Traefik on localhost:80):"
echo ""
echo "🚀 API Services:"
echo "  • API Gateway: http://localhost/api"
echo "  • Auth Service: http://localhost/auth"
echo "  • Tasks Service: http://localhost/tasks"
echo "  • Collections Service: http://localhost/collections"
echo "  • Forms Service: http://localhost/forms"
echo "  • Tags Service: http://localhost/tags"
echo ""
echo "📊 Monitoring & Infrastructure:"
echo "  • Traefik Dashboard: http://localhost:8081 (admin/admin)"
echo "  • Grafana: http://localhost/grafana (admin/admin)"
echo "  • Prometheus: http://localhost/prometheus"
echo "  • Keycloak Admin: http://localhost/auth/admin (admin/admin)"
echo "  • RabbitMQ Management: http://localhost/rabbitmq (intellifinder/intellifinder)"
echo ""
echo "🔧 Development Commands:"
echo "  • Start all services: make dev-local"
echo "  • Start only infrastructure: make dev-infra"
echo "  • Stop all services: docker compose down"
echo "  • View logs: docker compose logs -f [service-name]"
echo ""
echo "💡 Benefits of this setup:"
echo "  • No host file modifications required"
echo "  • No root privileges needed"
echo "  • Proper reverse proxy routing"
echo "  • Easy service discovery"
echo "  • Production-like environment"
echo ""
echo "🐳 To start the services now:"
echo "  make dev"
