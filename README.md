# Boiler-plate

A modular, location-aware task and documentation platform built with Go microservices architecture, designed to be scalable, secure, and adaptable to enterprise requirements.

## 🎯 Architecture Overview

Boiler-plate follows a microservices-first approach with the following key principles:

- **Microservices Architecture**: Each functional domain is a separate, independently deployable service
- **Test-Driven Development**: Comprehensive unit/integration testing for all services
- **Infrastructure-as-Code**: Declarative environment setup and scaling
- **Cloud-Agnostic**: Supports GKE, AWS EKS, European providers, and on-prem Kubernetes
- **Cross-Platform Frontend**: Single Angular codebase with Capacitor for web, iOS, and Android

## 🏗️ Project Structure

```
boilerplate/
├── contracts/                  # API contracts & proto files
│   ├── proto/                  # gRPC service definitions
│   │   ├── auth/               # Authentication service contracts
│   │   ├── tasks/              # Task management contracts
│   │   ├── collections/        # Collection management contracts
│   │   ├── forms/              # Form handling contracts
│   │   └── tags/               # Tagging system contracts
│   ├── openapi/                # REST API specifications
│   └── events/                 # Event schemas for async messaging
├── libs/                       # Shared Go libraries
│   ├── auth/                   # Authentication utilities
│   ├── database/               # Database abstractions
│   ├── messaging/              # RabbitMQ/event handling
│   ├── observability/          # Logging, metrics, tracing
│   ├── validation/             # Input validation
│   └── middleware/             # Common middleware
├── services/                   # Microservices
│   ├── auth/                   # Centralized authentication service
│   │   ├── cmd/                # Main application entry
│   │   ├── internal/           # Private application code
│   │   ├── pkg/                # Public packages
│   │   ├── api/                # Generated API code
│   │   ├── migrations/         # Database migrations
│   │   ├── configs/            # Configuration files
│   │   └── deploy/             # Deployment manifests
│   ├── tasks/                  # Task management service
│   ├── collections/            # Collection management service
│   ├── forms/                  # Form handling service
│   └── tags/                   # Tagging system service
├── gateway/                    # API Gateway
│   ├── cmd/                    # Gateway application entry
│   ├── internal/               # Gateway implementation
│   └── configs/                # Gateway configuration
├── infra/                      # Infrastructure as Code
│   ├── terraform/              # Terraform configurations
│   ├── helm/                   # Helm charts
│   └── k8s/                    # Kubernetes manifests
├── ops/                        # Operations tooling
│   ├── monitoring/             # Prometheus, Grafana configs
│   ├── scripts/                # Deployment scripts
│   └── docs/                   # Operational documentation
└── docs/                       # Project documentation
```

## 🔐 Authentication & Authorization

### Centralized Auth Service
- **JWT Token Validation**: Validates tokens from Keycloak
- **Role Management**: Syncs roles from Keycloak to local cache
- **Permission Checking**: Provides authorization helpers for other services
- **User Context**: Injects user information into service calls

### Keycloak Integration
- User roles are defined and managed in Keycloak
- Services handle authorization logic locally
- Centralized authentication with distributed authorization

## 🔗 Communication Patterns

### Internal Service Communication
- **gRPC**: Primary communication protocol between services
- **REST**: Used for external API exposure via API Gateway
- **Message Queue**: RabbitMQ for asynchronous workflows and events

### API Gateway
- JWT authentication validation
- Rate limiting and routing
- Request forwarding to appropriate microservices
- REST to gRPC translation

## 🛠️ Technology Stack

### Backend Services
- **Language**: Go 1.21+
- **Framework**: Gin (REST) + gRPC-Go
- **Database**: PostgreSQL with pgx driver
- **Cache**: Redis
- **Message Queue**: RabbitMQ
- **Authentication**: Keycloak with gocloak client

### Observability
- **Metrics**: Prometheus + Grafana
- **Logging**: Structured JSON logs with correlation IDs
- **Tracing**: OpenTelemetry
- **Error Tracking**: Sentry

### Infrastructure
- **Container**: Docker
- **Orchestration**: Kubernetes
- **IaC**: Terraform/OpenTofu
- **Package Management**: Helm

### Frontend
- **Framework**: Angular with Capacitor
- **Deployment**: Web, iOS, Android

## 🚀 Getting Started

### Prerequisites
- Go 1.21+
- Docker & Docker Compose
- Kubernetes cluster (local: minikube/kind)
- Keycloak instance
- PostgreSQL
- Redis
- RabbitMQ

### Development Setup

#### Option 1: Docker Compose (Recommended for Start)
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd boilerplate
   ```

2. **Start all services**
   ```bash
   make dev
   ```

3. **Access services**
   - API Gateway: http://localhost:80
   - Traefik Dashboard: http://localhost:8081 (admin/admin)
   - Grafana: http://localhost:3000 (admin/admin)
   - Prometheus: http://localhost:9090
   - Jaeger: http://localhost:16686
   - Keycloak Admin: http://keycloak.boilerplate.local (admin/admin)
   - RabbitMQ Management: http://rabbitmq.boilerplate.local (boilerplate/boilerplate)

#### Option 2: Minikube (Production Parity)
1. **Start minikube**
   ```bash
   make minikube-start
   ```

2. **Deploy to minikube**
   ```bash
   make deploy-minikube
   ```

3. **Access services**
   ```bash
   make minikube-tunnel
   # Then access via: http://api.boilerplate.local
   ```

#### Development Commands
```bash
# Start infrastructure only
make dev-infra

# Start application services only
make dev-services

# Start in minikube-like mode
make dev-minikube

# Start with Traefik gateway
make dev-traefik

# Check minikube status
make minikube-status
```

### Building Services

```bash
# Build all services
make build

# Build specific service
make build-auth
make build-gateway
```

### Testing

```bash
# Run all tests
make test

# Run tests for specific service
make test-auth

# Run integration tests
make test-integration
```

## 📋 Service Responsibilities

### Auth Service
- User authentication via Keycloak
- JWT token validation
- Role and permission management
- User context injection

### Tasks Service
- Task creation, updates, and management
- Task assignment and tracking
- Task status workflows

### Collections Service
- Collection organization
- Document management
- Collection sharing and permissions

### Forms Service
- Dynamic form creation
- Form submission handling
- Form validation and processing

### Tags Service
- Tag creation and management
- Tag-based categorization
- Tag search and filtering

## 🔍 Monitoring & Observability

### Metrics
- Service health and performance
- API request rates and latencies
- Database connection pools
- Message queue metrics

### Logging
- Structured JSON logs
- Correlation IDs for request tracing
- Error tracking and alerting

### Dashboards
- Infrastructure health monitoring
- API performance metrics
- Service dependency graphs
- Error rate tracking

## 🧪 Testing Strategy

### Backend Services
- **Unit Tests**: Core business logic
- **Integration Tests**: Service boundaries with testcontainers
- **Contract Tests**: gRPC service contracts
- **End-to-End Tests**: Critical user workflows

### CI/CD Pipeline
- Automated testing on every push
- Code quality checks
- Security scanning
- Automated deployment to staging

## 🚢 Deployment

### Kubernetes Deployment
```bash
# Deploy to staging
make deploy-staging

# Deploy to production
make deploy-prod
```

### Infrastructure Provisioning
```bash
# Provision infrastructure
cd infra/terraform
terraform init
terraform plan
terraform apply
```

## 📚 Documentation

- [Architecture Overview](docs/architecture.md)
- [API Documentation](docs/api.md)
- [Deployment Guide](docs/deployment.md)
- [Development Guide](docs/development.md)
- [Monitoring Guide](ops/docs/monitoring.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for your changes
4. Ensure all tests pass
5. Submit a pull request

## 📄 License

[Add your license information here]

## 🆘 Support

For questions and support:
- Create an issue in the repository
- Check the documentation in `/docs`
- Review operational guides in `/ops/docs`
