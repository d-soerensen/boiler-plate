# IntelliFinder V4 Makefile

.PHONY: help build test clean dev migrate-up migrate-down docker-build docker-push deploy-staging deploy-prod

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Build targets
build: ## Build all services
	@echo "Building all services..."
	@$(MAKE) build-auth
	@$(MAKE) build-gateway
	@$(MAKE) build-tasks
	@$(MAKE) build-collections
	@$(MAKE) build-forms
	@$(MAKE) build-tags

build-auth: ## Build auth service
	@echo "Building auth service..."
	@cd services/auth && go build -o bin/auth cmd/main.go

build-gateway: ## Build API gateway
	@echo "Building API gateway..."
	@cd gateway && go build -o bin/gateway cmd/main.go

build-tasks: ## Build tasks service
	@echo "Building tasks service..."
	@cd services/tasks && go build -o bin/tasks cmd/main.go

build-collections: ## Build collections service
	@echo "Building collections service..."
	@cd services/collections && go build -o bin/collections cmd/main.go

build-forms: ## Build forms service
	@echo "Building forms service..."
	@cd services/forms && go build -o bin/forms cmd/main.go

build-tags: ## Build tags service
	@echo "Building tags service..."
	@cd services/tags && go build -o bin/tags cmd/main.go

# Test targets
test: ## Run all tests
	@echo "Running all tests..."
	@$(MAKE) test-auth
	@$(MAKE) test-gateway
	@$(MAKE) test-tasks
	@$(MAKE) test-collections
	@$(MAKE) test-forms
	@$(MAKE) test-tags

test-auth: ## Run auth service tests
	@echo "Running auth service tests..."
	@cd services/auth && go test ./...

test-gateway: ## Run gateway tests
	@echo "Running gateway tests..."
	@cd gateway && go test ./...

test-tasks: ## Run tasks service tests
	@echo "Running tasks service tests..."
	@cd services/tasks && go test ./...

test-collections: ## Run collections service tests
	@echo "Running collections service tests..."
	@cd services/collections && go test ./...

test-forms: ## Run forms service tests
	@echo "Running forms service tests..."
	@cd services/forms && go test ./...

test-tags: ## Run tags service tests
	@echo "Running tags service tests..."
	@cd services/tags && go test ./...

test-integration: ## Run integration tests
	@echo "Running integration tests..."
	@go test ./tests/integration/...

# Development targets
dev: ## Start all services in development mode (Docker Compose)
	@echo "Starting all services in development mode..."
	@docker-compose up -d

dev-minikube: ## Start all services in minikube-like mode
	@echo "Starting services in minikube-like mode..."
	@docker-compose -f docker-compose.yml -f docker-compose.minikube.yml up -d

dev-traefik: ## Start all services with Traefik gateway
	@echo "Starting services with Traefik gateway..."
	@docker-compose -f docker-compose.yml -f docker-compose.traefik.yml up -d

dev-infra: ## Start only infrastructure services
	@echo "Starting infrastructure services..."
	@docker-compose up -d postgres redis rabbitmq keycloak prometheus grafana loki jaeger

dev-services: ## Start only application services
	@echo "Starting application services..."
	@docker-compose up -d auth-service gateway tasks-service collections-service forms-service tags-service

dev-auth: ## Start auth service in development mode
	@echo "Starting auth service..."
	@cd services/auth && go run cmd/main.go

dev-gateway: ## Start API gateway in development mode
	@echo "Starting API gateway..."
	@cd gateway && go run cmd/main.go

dev-tasks: ## Start tasks service in development mode
	@echo "Starting tasks service..."
	@cd services/tasks && go run cmd/main.go

dev-collections: ## Start collections service in development mode
	@echo "Starting collections service..."
	@cd services/collections && go run cmd/main.go

dev-forms: ## Start forms service in development mode
	@echo "Starting forms service..."
	@cd services/forms && go run cmd/main.go

dev-tags: ## Start tags service in development mode
	@echo "Starting tags service..."
	@cd services/tags && go run cmd/main.go

# Database migration targets
migrate-up: ## Run database migrations up
	@echo "Running database migrations up..."
	@cd services/auth && go run cmd/migrate.go up
	@cd services/tasks && go run cmd/migrate.go up
	@cd services/collections && go run cmd/migrate.go up
	@cd services/forms && go run cmd/migrate.go up
	@cd services/tags && go run cmd/migrate.go up

migrate-down: ## Run database migrations down
	@echo "Running database migrations down..."
	@cd services/auth && go run cmd/migrate.go down
	@cd services/tasks && go run cmd/migrate.go down
	@cd services/collections && go run cmd/migrate.go down
	@cd services/forms && go run cmd/migrate.go down
	@cd services/tags && go run cmd/migrate.go down

# Docker targets
docker-build: ## Build all Docker images
	@echo "Building Docker images..."
	@docker build -t intellifinder/auth:latest services/auth
	@docker build -t intellifinder/gateway:latest gateway
	@docker build -t intellifinder/tasks:latest services/tasks
	@docker build -t intellifinder/collections:latest services/collections
	@docker build -t intellifinder/forms:latest services/forms
	@docker build -t intellifinder/tags:latest services/tags

docker-push: ## Push Docker images to registry
	@echo "Pushing Docker images..."
	@docker push intellifinder/auth:latest
	@docker push intellifinder/gateway:latest
	@docker push intellifinder/tasks:latest
	@docker push intellifinder/collections:latest
	@docker push intellifinder/forms:latest
	@docker push intellifinder/tags:latest

# Deployment targets
deploy-staging: ## Deploy to staging environment
	@echo "Deploying to staging..."
	@cd infra/k8s && kubectl apply -f staging/

deploy-prod: ## Deploy to production environment
	@echo "Deploying to production..."
	@cd infra/k8s && kubectl apply -f production/

deploy-minikube: ## Deploy to minikube
	@echo "Deploying to minikube..."
	@minikube status || minikube start --memory=8192 --cpus=4
	@cd infra/k8s && kubectl apply -f minikube/

# Minikube targets
minikube-start: ## Start minikube cluster
	@echo "Starting minikube cluster..."
	@minikube start --memory=8192 --cpus=4 --driver=docker

minikube-stop: ## Stop minikube cluster
	@echo "Stopping minikube cluster..."
	@minikube stop

minikube-status: ## Check minikube status
	@echo "Checking minikube status..."
	@minikube status

minikube-tunnel: ## Start minikube tunnel for ingress
	@echo "Starting minikube tunnel..."
	@minikube tunnel

# Code generation targets
proto: ## Generate Go code from protobuf files
	@echo "Generating Go code from protobuf files..."
	@find contracts/proto -name "*.proto" -exec protoc --go_out=. --go-grpc_out=. {} \;

# Cleanup targets
clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf services/*/bin/
	@rm -rf gateway/bin/
	@rm -rf contracts/proto/*/*.pb.go

# Infrastructure targets
infra-plan: ## Plan infrastructure changes
	@echo "Planning infrastructure changes..."
	@cd infra/terraform && terraform plan

infra-apply: ## Apply infrastructure changes
	@echo "Applying infrastructure changes..."
	@cd infra/terraform && terraform apply

infra-destroy: ## Destroy infrastructure
	@echo "Destroying infrastructure..."
	@cd infra/terraform && terraform destroy

# Monitoring targets
monitor-start: ## Start monitoring stack
	@echo "Starting monitoring stack..."
	@cd ops/monitoring && docker-compose up -d

monitor-stop: ## Stop monitoring stack
	@echo "Stopping monitoring stack..."
	@cd ops/monitoring && docker-compose down

# Linting and formatting
lint: ## Run linters
	@echo "Running linters..."
	@golangci-lint run ./...

fmt: ## Format Go code
	@echo "Formatting Go code..."
	@go fmt ./...

# Dependencies
deps: ## Install dependencies
	@echo "Installing dependencies..."
	@go mod download
	@go mod tidy

deps-update: ## Update dependencies
	@echo "Updating dependencies..."
	@go get -u ./...
	@go mod tidy
