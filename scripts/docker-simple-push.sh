#!/bin/bash

# Script simplifié pour push Docker Hub - KABA-DELIVERY
# Usage: ./scripts/docker-simple-push.sh

set -e

echo "🐳 PUSH DOCKER HUB SIMPLIFIÉ - KABA-DELIVERY"
echo "============================================"

# Vérification Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "❌ Docker n'est pas démarré"
    echo "👉 Démarrez Docker Desktop puis relancez ce script"
    exit 1
fi

echo "✅ Docker disponible"

# Configuration
read -p "Nom d'utilisateur Docker Hub: " DOCKER_USERNAME
read -s -p "Token Docker Hub: " DOCKER_PASSWORD
echo ""

IMAGE_NAME="kaba-delivery"
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME"

# Connexion Docker Hub
echo "🔐 Connexion à Docker Hub..."
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

if [ $? -ne 0 ]; then
    echo "❌ Échec de la connexion Docker Hub"
    exit 1
fi

echo "✅ Connexion réussie"

# Build de l'application
echo "📦 Build de l'application..."
npm install
npm run build

# Build Docker
echo "🐳 Construction de l'image Docker..."
docker build -t "$FULL_IMAGE_NAME:latest" .

if [ $? -ne 0 ]; then
    echo "❌ Échec du build Docker"
    exit 1
fi

echo "✅ Image construite"

# Push vers Docker Hub
echo "📤 Push vers Docker Hub..."
docker push "$FULL_IMAGE_NAME:latest"

if [ $? -eq 0 ]; then
    echo "🎉 SUCCESS! Image poussée vers Docker Hub"
    echo "👉 Votre image: https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME"
    
    # Sauvegarder les infos
    echo "DOCKER_USERNAME=$DOCKER_USERNAME" > .docker-info
    echo "DOCKER_IMAGE_NAME=$FULL_IMAGE_NAME" >> .docker-info
    
    echo "✅ Informations sauvegardées dans .docker-info"
else
    echo "❌ Échec du push"
    exit 1
fi

# Nettoyage
rm -rf dist
echo "🧹 Nettoyage terminé"