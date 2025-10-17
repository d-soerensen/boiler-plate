# IntelliFinder V4 Development Environment Guide

## 🚀 Development Environment Options

### Option 1: Docker Compose (Recommended for Start)
**Best for**: Rapid development, debugging, team onboarding

```bash
# Start all services
docker-compose up -d

# Start specific services
docker-compose up -d postgres redis rabbitmq keycloak prometheus grafana

# View logs
docker-compose logs -f auth-service

# Scale services
docker-compose up -d --scale tasks-service=3
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

### 1. Local Development (Docker Compose)
```bash
# Start infrastructure
make dev-infra

# Start services with hot-reload
make dev-services

# Run tests
make test

# View monitoring
open http://localhost:3000  # Grafana
open http://localhost:9090  # Prometheus
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
        image: intellifinder/auth:latest
        ports:
        - containerPort: 8080
        env:
        - name: LOG_LEVEL
          value: "info"
```

## 🔍 Monitoring Differences

### Development
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **Loki**: http://localhost:3100
- **Traefik Dashboard**: http://localhost:8081 (admin/admin)

### Production
- **Grafana**: https://grafana.intellifinder.com
- **Prometheus**: https://prometheus.intellifinder.com
- **Jaeger**: https://jaeger.intellifinder.com
- **Loki**: Internal service discovery

## 🚀 Getting Started

### Quick Start (Docker Compose)
```bash
# Clone and setup
git clone <repo>
cd intellifinder/v4

# Start everything
make dev

# Access services
curl http://localhost:8080/health  # Gateway
curl http://localhost:8081/health  # Auth service
```

### Production Testing (Minikube)
```bash
# Setup minikube
minikube start --memory=8192 --cpus=4

# Deploy services
make deploy-minikube

# Access via ingress
minikube tunnel
curl http://api.intellifinder.local/health
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

**Start with Docker Compose + Traefik** for these reasons:

1. **Faster Development**: Quick iteration and debugging
2. **Lower Resource Usage**: Better for local machines
3. **Easier Onboarding**: Team members can start quickly
4. **Sufficient Testing**: Can test most functionality

**Move to Minikube** when you need:

1. **Production Parity**: Testing Kubernetes-specific features
2. **Service Mesh**: Istio/Linkerd integration
3. **Auto-scaling**: Testing horizontal pod autoscaling
4. **CI/CD**: Kubernetes deployment pipelines

## 🔧 Next Steps

1. **Implement Docker Compose setup** (already done!)
2. **Add hot-reload configuration**
3. **Create Kubernetes manifests**
4. **Setup minikube environment**
5. **Implement Helm charts**

This hybrid approach gives you the best of both worlds: fast development with Docker Compose and production testing with Kubernetes.
