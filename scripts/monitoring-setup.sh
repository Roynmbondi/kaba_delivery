#!/bin/bash

# Script de configuration du monitoring pour KABA-DELIVERY
# Usage: ./scripts/monitoring-setup.sh

set -e

echo "🔧 Configuration du monitoring KABA-DELIVERY"

# Création des répertoires nécessaires
echo "📁 Création des répertoires..."
mkdir -p monitoring/data/{elasticsearch,prometheus,grafana}
mkdir -p logs

# Attribution des permissions
echo "🔐 Configuration des permissions..."
sudo chown -R 1000:1000 monitoring/data/elasticsearch
sudo chown -R 472:472 monitoring/data/grafana
sudo chown -R 65534:65534 monitoring/data/prometheus

# Démarrage de la stack de monitoring
echo "🚀 Démarrage de la stack de monitoring..."
docker-compose -f monitoring/docker-compose.monitoring.yml up -d

# Attente du démarrage des services
echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérification des services
echo "🔍 Vérification des services..."

services=("elasticsearch:9200" "kibana:5601" "prometheus:9090" "grafana:3001")
for service in "${services[@]}"; do
    IFS=':' read -r name port <<< "$service"
    if curl -f http://localhost:$port > /dev/null 2>&1; then
        echo "✅ $name est accessible sur le port $port"
    else
        echo "❌ $name n'est pas accessible sur le port $port"
    fi
done

# Configuration initiale de Kibana
echo "🔧 Configuration initiale de Kibana..."
sleep 10
curl -X POST "localhost:5601/api/index_patterns/index_pattern" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "index_pattern": {
      "title": "kaba-delivery-logs-*",
      "timeFieldName": "@timestamp"
    }
  }' || echo "Index pattern déjà configuré"

echo "🎉 Configuration du monitoring terminée!"
echo ""
echo "📊 Accès aux services:"
echo "  - Kibana (Logs): http://localhost:5601"
echo "  - Grafana (Métriques): http://localhost:3001 (admin/admin123)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Elasticsearch: http://localhost:9200"
echo ""
echo "📝 Pour voir les logs de l'application:"
echo "  docker logs kaba-delivery"