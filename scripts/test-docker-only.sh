#!/bin/bash

# Script de test Docker uniquement - KABA-DELIVERY
# Test rapide de la conteneurisation
# Usage: ./scripts/test-docker-only.sh

set -e

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

echo -e "${BLUE}"
echo "🐳 TEST DOCKER KABA-DELIVERY"
echo "============================="
echo -e "${NC}"

# Vérification Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé"
    exit 1
fi

print_success "Docker détecté: $(docker --version)"

# Variables
IMAGE_NAME="kaba-delivery-test"
CONTAINER_NAME="kaba-test"
PORT="3001"

# Nettoyage préalable
echo "🧹 Nettoyage préalable..."
docker stop "$CONTAINER_NAME" 2>/dev/null || true
docker rm "$CONTAINER_NAME" 2>/dev/null || true
docker rmi "$IMAGE_NAME" 2>/dev/null || true

# Construction de l'image
echo "🔨 Construction de l'image Docker..."
if docker build -t "$IMAGE_NAME" .; then
    print_success "Image construite avec succès"
    
    # Informations sur l'image
    IMAGE_SIZE=$(docker images "$IMAGE_NAME" --format "table {{.Size}}" | tail -1)
    print_info "Taille de l'image: $IMAGE_SIZE"
else
    print_error "Échec de la construction de l'image"
    exit 1
fi

# Test de démarrage
echo "🚀 Démarrage du conteneur..."
if docker run -d --name "$CONTAINER_NAME" -p "$PORT:3000" "$IMAGE_NAME"; then
    print_success "Conteneur démarré sur le port $PORT"
else
    print_error "Échec du démarrage du conteneur"
    exit 1
fi

# Attente et test
echo "⏳ Attente du démarrage de l'application (15 secondes)..."
sleep 15

# Vérification des logs
echo "📋 Logs du conteneur:"
docker logs "$CONTAINER_NAME" --tail 10

# Test de connectivité
echo ""
echo "🌐 Test de connectivité..."
if curl -f "http://localhost:$PORT" > /dev/null 2>&1; then
    print_success "Application accessible sur http://localhost:$PORT"
    echo ""
    print_info "🎉 Vous pouvez maintenant tester l'application dans votre navigateur:"
    print_info "   👉 http://localhost:$PORT"
    echo ""
    
    read -p "Appuyez sur Entrée pour arrêter le conteneur et nettoyer..."
else
    print_error "Application non accessible"
    echo "Vérification des logs pour diagnostic:"
    docker logs "$CONTAINER_NAME"
fi

# Nettoyage
echo ""
echo "🧹 Nettoyage..."
docker stop "$CONTAINER_NAME"
docker rm "$CONTAINER_NAME"
docker rmi "$IMAGE_NAME"

print_success "Test Docker terminé et nettoyé"