#!/bin/bash

# Script de déploiement pour KABA-DELIVERY sur O2Switch
# Usage: ./scripts/deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
DOCKER_IMAGE="kaba-delivery"
CONTAINER_NAME="kaba-delivery"
PORT=3000

echo "🚀 Déploiement de KABA-DELIVERY en environnement: $ENVIRONMENT"

# Vérification des prérequis
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

# Arrêt et suppression de l'ancien conteneur
echo "🛑 Arrêt de l'ancien conteneur..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Suppression de l'ancienne image
echo "🗑️ Suppression de l'ancienne image..."
docker rmi $DOCKER_IMAGE:latest 2>/dev/null || true

# Téléchargement de la nouvelle image
echo "📥 Téléchargement de la nouvelle image..."
docker pull $DOCKER_USERNAME/$DOCKER_IMAGE:latest

# Lancement du nouveau conteneur
echo "🚀 Lancement du nouveau conteneur..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p $PORT:$PORT \
  -e NODE_ENV=$ENVIRONMENT \
  -e PORT=$PORT \
  $DOCKER_USERNAME/$DOCKER_IMAGE:latest

# Vérification du déploiement
echo "🔍 Vérification du déploiement..."
sleep 10

if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Conteneur démarré avec succès"
else
    echo "❌ Échec du démarrage du conteneur"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Test de santé
echo "🏥 Test de santé de l'application..."
if curl -f http://localhost:$PORT > /dev/null 2>&1; then
    echo "✅ Application accessible et fonctionnelle"
else
    echo "❌ Application non accessible"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Nettoyage
echo "🧹 Nettoyage des ressources inutilisées..."
docker system prune -f

echo "🎉 Déploiement terminé avec succès!"
echo "🌐 Application disponible sur: http://localhost:$PORT"