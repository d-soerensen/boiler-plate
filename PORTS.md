# IntelliFinder V4 Port Mapping

## External Ports (Host → Container)

### Core Services
- **80** → Traefik (HTTP)
- **443** → Traefik (HTTPS)
- **8081** → Traefik Dashboard (admin/admin)

### Infrastructure Services
- **5432** → PostgreSQL
- **6379** → Redis
- **5672** → RabbitMQ (AMQP)
- **15672** → RabbitMQ Management UI
- **8080** → Keycloak

### Monitoring Services
- **3000** → Grafana (admin/admin)
- **9090** → Prometheus
- **3100** → Loki
- **16686** → Jaeger
- **14268** → Jaeger (OTLP)

## Internal Service Communication
All services communicate internally using container names and internal ports:
- **Traefik**: `traefik:8080` (dashboard), `traefik:80` (HTTP), `traefik:443` (HTTPS)
- **PostgreSQL**: `postgres:5432`
- **Redis**: `redis:6379`
- **RabbitMQ**: `rabbitmq:5672`
- **Keycloak**: `keycloak:8080`
- **Auth Service**: `auth-service:8080`
- **Tasks Service**: `tasks-service:8080`
- **Collections Service**: `collections-service:8080`
- **Forms Service**: `forms-service:8080`
- **Tags Service**: `tags-service:8080`
- **Gateway**: `gateway:8080`

## Development Access

### Via Traefik (Recommended)
- **API Gateway**: http://api.intellifinder.local
- **Traefik Dashboard**: http://localhost:8081 (admin/admin)
- **Grafana**: http://grafana.intellifinder.local (admin/admin)
- **Prometheus**: http://prometheus.intellifinder.local
- **Jaeger**: http://jaeger.intellifinder.local
- **Keycloak Admin**: http://keycloak.intellifinder.local (admin/admin)
- **RabbitMQ Management**: http://rabbitmq.intellifinder.local (intellifinder/intellifinder)

### Direct Port Access (Fallback)
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **RabbitMQ AMQP**: localhost:5672
