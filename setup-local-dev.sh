#!/bin/bash

# IntelliFinder V4 Local Development Setup Script

echo "🚀 Setting up IntelliFinder V4 local development environment..."

# Check if running on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    HOSTS_FILE="/etc/hosts"
    echo "📱 Detected macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    HOSTS_FILE="/etc/hosts"
    echo "🐧 Detected Linux"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    exit 1
fi

# Check if running as root (needed for hosts file modification)
if [[ $EUID -ne 0 ]]; then
    echo "⚠️  This script needs to modify $HOSTS_FILE"
    echo "Please run with sudo: sudo ./setup-local-dev.sh"
    exit 1
fi

# Backup existing hosts file
echo "📋 Backing up existing hosts file..."
cp "$HOSTS_FILE" "$HOSTS_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# Add IntelliFinder V4 entries to hosts file
echo "🌐 Adding IntelliFinder V4 entries to hosts file..."

# Check if entries already exist
if grep -q "intellifinder.local" "$HOSTS_FILE"; then
    echo "✅ IntelliFinder V4 entries already exist in hosts file"
else
    cat >> "$HOSTS_FILE" << EOF

# IntelliFinder V4 Local Development
127.0.0.1 api.intellifinder.local
127.0.0.1 auth.intellifinder.local
127.0.0.1 tasks.intellifinder.local
127.0.0.1 collections.intellifinder.local
127.0.0.1 forms.intellifinder.local
127.0.0.1 tags.intellifinder.local
127.0.0.1 traefik.intellifinder.local
127.0.0.1 grafana.intellifinder.local
127.0.0.1 prometheus.intellifinder.local
127.0.0.1 jaeger.intellifinder.local
127.0.0.1 loki.intellifinder.local
127.0.0.1 keycloak.intellifinder.local
127.0.0.1 rabbitmq.intellifinder.local
EOF
    echo "✅ Added IntelliFinder V4 entries to hosts file"
fi

echo ""
echo "🎉 Setup complete! You can now access:"
echo ""
echo "📊 Monitoring:"
echo "  • Traefik Dashboard: http://localhost:8081 (admin/admin)"
echo "  • Grafana: http://grafana.intellifinder.local (admin/admin)"
echo "  • Prometheus: http://prometheus.intellifinder.local"
echo "  • Jaeger: http://jaeger.intellifinder.local"
echo ""
echo "🔐 Authentication & Infrastructure:"
echo "  • Keycloak Admin: http://keycloak.intellifinder.local (admin/admin)"
echo "  • RabbitMQ Management: http://rabbitmq.intellifinder.local (intellifinder/intellifinder)"
echo ""
echo "🚀 API Services:"
echo "  • API Gateway: http://api.intellifinder.local"
echo "  • Auth Service: http://auth.intellifinder.local"
echo "  • Tasks Service: http://tasks.intellifinder.local"
echo "  • Collections Service: http://collections.intellifinder.local"
echo "  • Forms Service: http://forms.intellifinder.local"
echo "  • Tags Service: http://tags.intellifinder.local"
echo ""
echo "🐳 To start the services:"
echo "  make dev"
echo ""
echo "📝 To restore hosts file:"
echo "  sudo cp $HOSTS_FILE.backup.* $HOSTS_FILE"
