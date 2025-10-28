# Boiler-plate Development Environment Guide

## 🚀 Development Environment Options

### Option 1: Docker Compose with Traefik (Default)
**Best for**: Rapid development, debugging, team onboarding, no host file modifications

```bash
# Setup (one-time)
./setup-local-dev.sh

# Start all services with Traefik routing
make dev

# Access services via localhost
curl http://localhost/api/health
curl http://localhost/auth/health
curl http://localhost/tasks/health
```

### Option 2: Minikube/Kind (Production Parity)
**Best for**: Production testing, Kubernetes features, CI/CD

```bash
# Start minikube
minikube start --memory=8192 --cpus=4

# Deploy to minikube
make deploy-minikube

# Access services
minikube service auth-service --url
```

## 🏗️ Environment Configuration

### Development Services (Docker Compose)
- **Core Services**: auth, tasks, collections, forms, tags, gateway
- **Infrastructure**: postgres, redis, rabbitmq, keycloak
- **Monitoring**: prometheus, grafana, loki, jaeger
- **Development Tools**: hot-reload, debug ports, local volumes

### Production Services (Kubernetes)
- **Core Services**: Same as dev
- **Infrastructure**: Managed services (Cloud SQL, Redis, etc.)
- **Monitoring**: External Prometheus/Grafana instances
- **Production Features**: auto-scaling, health checks, secrets management

## 🔧 Development Workflow

### 1. Local Development (Default)
```bash
# One-time setup
./setup-local-dev.sh

# Start all services with Traefik routing
make dev

# Run tests
make test

# View monitoring
open http://localhost/grafana     # Grafana
open http://localhost/prometheus  # Prometheus
open http://localhost:8081         # Traefik Dashboard
```

### 2. Production Testing (Minikube)
```bash
# Deploy to minikube
make deploy-minikube

# Run integration tests
make test-integration-k8s

# Check service health
kubectl get pods
kubectl logs -f deployment/auth-service
```

## 📊 Service Configuration

### Development Configuration
```yaml
# docker-compose.yml
services:
  auth-service:
    build: ./services/auth
    ports:
      - "8080:8080"  # Direct access
    environment:
      - LOG_LEVEL=debug
      - HOT_RELOAD=true
    volumes:
      - ./services/auth:/app  # Hot reload
```

### Production Configuration
```yaml
# k8s/auth-service.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: auth-service
  template:
    spec:
      containers:
      - name: auth-service
        image: boilerplate/auth:latest
        ports:
        - containerPort: 8080
        env:
        - name: LOG_LEVEL
          value: "info"
```

## 🔍 Monitoring Differences

### Development (Default)
- **Grafana**: http://localhost/grafana (admin/admin)
- **Prometheus**: http://localhost/prometheus
- **Jaeger**: http://localhost:16686
- **Loki**: http://localhost:3100
- **Traefik Dashboard**: http://localhost:8081 (admin/admin)
- **Keycloak Admin**: http://localhost/auth/admin (admin/admin)
- **RabbitMQ Management**: http://localhost/rabbitmq (boilerplate/boilerplate)

### Production
- **Grafana**: https://grafana.boilerplate.com
- **Prometheus**: https://prometheus.boilerplate.com
- **Jaeger**: https://jaeger.boilerplate.com
- **Loki**: Internal service discovery

## 🚀 Getting Started

### Quick Start (Default)
```bash
# Clone and setup
git clone <repo>
cd boilerplate/platform

# One-time setup (no root privileges needed!)
./setup-local-dev.sh

# Start all services
make dev

# Access services via Traefik
curl http://localhost/api/health      # Gateway
curl http://localhost/auth/health      # Auth service
curl http://localhost/tasks/health    # Tasks service
```

### Production Testing (Minikube)
```bash
# Setup minikube
minikube start --memory=8192 --cpus=4

# Deploy services
make deploy-minikube

# Access via ingress
minikube tunnel
curl http://api.boilerplate.local/health
```

## 🔄 Migration Path

### Phase 1: Docker Compose Development
1. Start with Docker Compose
2. Develop and test services
3. Implement monitoring
4. Write comprehensive tests

### Phase 2: Kubernetes Integration
1. Create Kubernetes manifests
2. Test with minikube
3. Implement Helm charts
4. Setup CI/CD pipeline

### Phase 3: Production Deployment
1. Deploy to staging (Kubernetes)
2. Load testing
3. Production deployment
4. Monitoring and alerting

## 🛠️ Development Tools

### Docker Compose Tools
- **Hot Reload**: File watching and auto-restart
- **Debug Ports**: Delve debugger integration
- **Local Volumes**: Persistent data and logs
- **Network Isolation**: Service communication

### Kubernetes Tools
- **kubectl**: Cluster management
- **Helm**: Package management
- **Skaffold**: Development workflow
- **Tilt**: Live updates

## 📈 Performance Comparison

| Aspect | Docker Compose | Minikube |
|--------|----------------|----------|
| **Startup Time** | ~30s | ~2-3min |
| **Memory Usage** | ~2GB | ~4-6GB |
| **CPU Usage** | Low | Medium |
| **Development Speed** | Fast | Slower |
| **Production Parity** | Low | High |

## 🚀 Traefik Gateway Features

### Automatic Service Discovery
- **Docker Labels**: Services automatically discovered via Docker labels
- **Dynamic Routing**: Routes updated automatically when services start/stop
- **Load Balancing**: Built-in load balancing across service instances

### Advanced Middleware
- **Rate Limiting**: Protect services from abuse
- **Circuit Breaker**: Prevent cascade failures
- **CORS**: Handle cross-origin requests
- **Authentication**: Forward auth to auth service
- **Security Headers**: Add security headers automatically

### Monitoring & Observability
- **Prometheus Metrics**: Built-in metrics collection
- **Access Logs**: Detailed request/response logging
- **Dashboard**: Real-time service status and routing
- **Health Checks**: Automatic service health monitoring

### Development Benefits
- **Hot Reload**: Configuration changes without restart
- **Service Mesh Ready**: Easy migration to Istio/Linkerd
- **SSL/TLS**: Automatic HTTPS with Let's Encrypt
- **Multi-Protocol**: HTTP, HTTPS, gRPC, WebSocket support

## 🎯 Recommendation

**Use Docker Compose with Traefik (Default)** for these reasons:

1. **No Host File Modifications**: No root privileges required
2. **Production-like Routing**: Proper reverse proxy setup
3. **Faster Development**: Quick iteration and debugging
4. **Easier Onboarding**: Team members can start quickly
5. **Service Discovery**: Automatic service registration
6. **Advanced Middleware**: Rate limiting, CORS, authentication

**Move to Minikube** when you need:

1. **Production Parity**: Testing Kubernetes-specific features
2. **Service Mesh**: Istio/Linkerd integration
3. **Auto-scaling**: Testing horizontal pod autoscaling
4. **CI/CD**: Kubernetes deployment pipelines

## 🔧 Next Steps

1. **Docker Compose with Traefik** (already implemented!)
2. **Add hot-reload configuration**
3. **Create Kubernetes manifests**
4. **Setup minikube environment**
5. **Implement Helm charts**

This approach gives you fast development with Traefik and production testing with Kubernetes.
