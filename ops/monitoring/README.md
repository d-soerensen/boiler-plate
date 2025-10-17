# IntelliFinder V4 Monitoring Stack

This directory contains the monitoring and observability configuration for IntelliFinder V4.

## 🏗️ Components

### Core Monitoring
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation
- **Promtail**: Log collection
- **Jaeger**: Distributed tracing

### System Monitoring
- **Node Exporter**: System metrics (CPU, memory, disk, network)
- **cAdvisor**: Container metrics

## 🚀 Quick Start

### Start Monitoring Stack
```bash
cd ops/monitoring
docker-compose up -d
```

### Access Services
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Jaeger**: http://localhost:16686
- **Loki**: http://localhost:3100

## 📊 Dashboards

### IntelliFinder Overview Dashboard
- Service request rates
- Response time percentiles
- Error rates
- Memory usage
- Garbage collection metrics
- Goroutine counts

### Database & Infrastructure Dashboard
- PostgreSQL connections and operations
- Redis connections and commands
- RabbitMQ queue metrics
- System resource utilization

## 🔧 Configuration

### Prometheus (`prometheus.yml`)
- Scrapes metrics from all services
- Configures service discovery
- Sets up alerting rules

### Grafana
- **Datasources**: Prometheus, Loki, Jaeger
- **Dashboards**: Pre-configured service and infrastructure dashboards
- **Provisioning**: Automatic datasource and dashboard setup

### Loki (`promtail.yml`)
- Collects container logs
- Parses structured logs
- Sends to Loki for storage

## 📈 Metrics

### Service Metrics
Each service should expose the following metrics:

```go
// HTTP request metrics
http_requests_total{method, path, status}
http_request_duration_seconds{method, path}

// Go runtime metrics
go_memstats_heap_inuse_bytes
go_memstats_heap_alloc_bytes
go_gc_duration_seconds_sum
go_goroutines

// Custom business metrics
business_operations_total{operation, status}
```

### Database Metrics
- PostgreSQL: Via postgres_exporter
- Redis: Via redis_exporter
- RabbitMQ: Via rabbitmq_exporter

## 🔍 Logging

### Structured Logging
All services should use structured JSON logging:

```go
log.Info("request processed",
    zap.String("method", "GET"),
    zap.String("path", "/api/v1/tasks"),
    zap.Int("status", 200),
    zap.Duration("duration", duration),
    zap.String("trace_id", traceID),
)
```

### Log Levels
- **ERROR**: System errors, exceptions
- **WARN**: Recoverable issues, deprecations
- **INFO**: Important business events
- **DEBUG**: Detailed debugging information

## 🔗 Tracing

### OpenTelemetry Integration
Services should instrument with OpenTelemetry:

```go
// HTTP middleware
tracer := otel.Tracer("intellifinder/auth")
span := tracer.Start(ctx, "auth.validate_token")
defer span.End()

// Database operations
span := tracer.Start(ctx, "db.query")
defer span.End()
```

## 🚨 Alerting

### Alert Rules
Create alert rules in Prometheus for:
- High error rates (>5%)
- High response times (>1s p95)
- High memory usage (>80%)
- Service down
- Database connection issues

### Notification Channels
Configure Grafana notification channels:
- Slack
- Email
- PagerDuty
- Webhook

## 🛠️ Development

### Adding New Metrics
1. Add metric definitions to service
2. Update Prometheus scrape config
3. Create/update Grafana dashboard
4. Add alert rules if needed

### Adding New Dashboards
1. Create dashboard JSON in `grafana/dashboards/`
2. Update `grafana/dashboards/dashboards.yml`
3. Restart Grafana

### Custom Dashboards
Create custom dashboards for:
- Business metrics
- User behavior
- Performance trends
- Capacity planning

## 📚 Resources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Loki Documentation](https://grafana.com/docs/loki/)
- [Jaeger Documentation](https://www.jaegertracing.io/docs/)
- [OpenTelemetry Go](https://opentelemetry.io/docs/go/)

## 🔧 Troubleshooting

### Common Issues
1. **Metrics not appearing**: Check service endpoints and Prometheus targets
2. **Logs not showing**: Verify Promtail configuration and Loki connectivity
3. **Dashboards empty**: Check datasource connections and metric names
4. **High memory usage**: Adjust retention policies and scrape intervals

### Debug Commands
```bash
# Check Prometheus targets
curl http://localhost:9090/api/v1/targets

# Check Loki targets
curl http://localhost:3100/api/prom/targets

# Check Grafana datasources
curl -u admin:admin http://localhost:3000/api/datasources
```
