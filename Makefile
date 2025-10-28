# IntelliFinder V4 Makefile - Developer Friendly

.PHONY: help setup dev dev-stop dev-logs test test-watch migrate-up migrate-down proto build-service build-all fmt lint deps clean

# Default target
help: ## Show this help message
	@echo '🚀 IntelliFinder V4 - Quick Start Commands'
	@echo ''
	@echo 'Essential Commands:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ''
	@echo '📖 Quick Start:'
	@echo '  1. make setup    # One-time setup'
	@echo '  2. make dev      # Start development environment'
	@echo '  3. make test     # Run tests'
	@echo ''
	@echo '🌐 Access Services:'
	@echo '  • Traefik Dashboard: http://localhost:8081 (admin/admin)'
	@echo '  • Grafana: http://localhost/grafana (admin/admin)'
	@echo '  • Prometheus: http://localhost/prometheus'
	@echo '  • Keycloak: http://localhost/auth/admin (admin/admin)'
	@echo '  • RabbitMQ Management: http://localhost:15672 (intellifinder/intellifinder)'

# Development Commands
setup: ## One-time setup (run this first!)
	@echo "🚀 Setting up IntelliFinder V4 development environment..."
	@./setup-local-dev.sh

dev: ## Start development environment with Traefik
	@echo "🚀 Starting IntelliFinder V4 development environment..."
	@docker compose up -d postgres redis rabbitmq prometheus grafana loki jaeger traefik
	@echo "⏳ Waiting for PostgreSQL to be ready..."
	@until docker compose exec postgres pg_isready -U intellifinder; do sleep 1; done
	@echo "🗄️ Setting up Keycloak database..."
	@docker compose exec postgres psql -U intellifinder -d intellifinder -c "CREATE DATABASE keycloak;" 2>/dev/null || echo "Keycloak database already exists"
	@echo "🔐 Starting Keycloak..."
	@docker compose up -d keycloak

dev-stop: ## Stop all services
	@echo "🛑 Stopping all services..."
	@docker compose down

dev-db-setup: ## Setup databases (Keycloak, etc.)
	@echo "🗄️ Setting up databases..."
	@docker compose up -d postgres
	@echo "⏳ Waiting for PostgreSQL to be ready..."
	@until docker compose exec postgres pg_isready -U intellifinder; do sleep 1; done
	@echo "🔐 Creating Keycloak database..."
	@docker compose exec postgres psql -U intellifinder -d intellifinder -c "CREATE DATABASE keycloak;" 2>/dev/null || echo "Keycloak database already exists"
	@echo "✅ Database setup complete!"

dev-logs: ## View logs from all services
	@echo "📋 Viewing logs from all services..."
	@docker compose logs -f

# Testing
test: ## Run all tests
	@echo "🧪 Running all tests..."
	@go test ./...

test-watch: ## Run tests in watch mode
	@echo "👀 Running tests in watch mode..."
	@go test ./... -watch

# Database & Code Generation
migrate-up: ## Run database migrations
	@echo "🗄️ Running database migrations..."
	@go run ./scripts/migrate.go up

migrate-down: ## Rollback database migrations
	@echo "🗄️ Rolling back database migrations..."
	@go run ./scripts/migrate.go down

proto: ## Generate Go code from protobuf files
	@echo "🔧 Generating Go code from protobuf files..."
	@find contracts/proto -name "*.proto" -exec protoc --go_out=. --go-grpc_out=. {} \;

build-service: ## Build a specific service (usage: make build-service SERVICE=auth)
	@echo "🔨 Building $(SERVICE) service..."
	@cd services/$(SERVICE) && go build -o bin/$(SERVICE) cmd/main.go

build-all: ## Build all services
	@echo "🔨 Building all services..."
	@for service in auth tasks collections forms tags; do \
		echo "Building $$service..."; \
		cd services/$$service && go build -o bin/$$service cmd/main.go && cd ../..; \
	done
	@echo "Building gateway..."
	@cd gateway && go build -o bin/gateway cmd/main.go

# Code Quality
fmt: ## Format Go code
	@echo "✨ Formatting Go code..."
	@go fmt ./...

lint: ## Run linters
	@echo "🔍 Running linters..."
	@golangci-lint run ./...

deps: ## Install/update dependencies
	@echo "📦 Installing dependencies..."
	@go mod download
	@go mod tidy

# Cleanup
clean: ## Clean build artifacts and containers
	@echo "🧹 Cleaning up..."
	@rm -rf services/*/bin/ gateway/bin/ contracts/proto/*/*.pb.go
	@docker compose down --volumes --remove-orphans
