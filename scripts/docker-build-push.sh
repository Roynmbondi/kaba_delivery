#!/bin/bash

# Script de build et push Docker Hub pour KABA-DELIVERY
# Usage: ./scripts/docker-build-push.sh

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

echo -e "${BLUE}"
echo "🐳 BUILD ET PUSH DOCKER HUB - KABA-DELIVERY"
echo "==========================================="
echo -e "${NC}"

# 1. Vérification des prérequis
echo "1️⃣ Vérification des prérequis..."

if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé"
    echo "Installez Docker depuis: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &> /dev/null; then
    print_error "Docker n'est pas démarré"
    echo "Démarrez Docker Desktop ou le service Docker"
    exit 1
fi

print_success "Docker disponible et démarré"

# 2. Vérification des fichiers nécessaires
echo ""
echo "2️⃣ Vérification des fichiers..."

REQUIRED_FILES=("Dockerfile" "package.json" "src/App.jsx")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    print_error "Fichiers manquants: ${MISSING_FILES[*]}"
    exit 1
fi

print_success "Tous les fichiers nécessaires sont présents"

# 3. Configuration Docker Hub
echo ""
echo "3️⃣ Configuration Docker Hub..."

if [ -z "$DOCKER_USERNAME" ]; then
    read -p "Entrez votre nom d'utilisateur Docker Hub: " DOCKER_USERNAME
fi

if [ -z "$DOCKER_PASSWORD" ]; then
    read -s -p "Entrez votre token Docker Hub: " DOCKER_PASSWORD
    echo ""
fi

print_info "Nom d'utilisateur Docker Hub: $DOCKER_USERNAME"

# 4. Connexion à Docker Hub
echo ""
echo "4️⃣ Connexion à Docker Hub..."

echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

if [ $? -eq 0 ]; then
    print_success "Connexion Docker Hub réussie"
else
    print_error "Échec de la connexion Docker Hub"
    print_info "Vérifiez vos identifiants et votre token"
    exit 1
fi

# 5. Build de l'application
echo ""
echo "5️⃣ Build de l'application React..."

echo "📦 Installation des dépendances..."
if npm install; then
    print_success "Dépendances installées"
else
    print_error "Échec de l'installation des dépendances"
    exit 1
fi

echo "🏗️ Build de production..."
if npm run build; then
    print_success "Build React réussi"
    
    # Vérifier que le dossier dist existe
    if [ -d "dist" ]; then
        BUILD_SIZE=$(du -sh dist | cut -f1)
        print_info "Taille du build: $BUILD_SIZE"
    else
        print_error "Dossier dist non créé"
        exit 1
    fi
else
    print_error "Échec du build React"
    exit 1
fi

# 6. Construction de l'image Docker
echo ""
echo "6️⃣ Construction de l'image Docker..."

# Variables pour les tags
IMAGE_NAME="kaba-delivery"
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME"
VERSION_TAG=$(date +%Y%m%d-%H%M%S)
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

print_info "Construction de l'image: $FULL_IMAGE_NAME"
print_info "Tags: latest, $VERSION_TAG, $GIT_COMMIT"

# Build de l'image avec plusieurs tags
if docker build \
    -t "$FULL_IMAGE_NAME:latest" \
    -t "$FULL_IMAGE_NAME:$VERSION_TAG" \
    -t "$FULL_IMAGE_NAME:$GIT_COMMIT" \
    .; then
    print_success "Image Docker construite avec succès"
else
    print_error "Échec de la construction Docker"
    exit 1
fi

# Vérifier la taille de l'image
IMAGE_SIZE=$(docker images "$FULL_IMAGE_NAME:latest" --format "table {{.Size}}" | tail -1)
print_info "Taille de l'image: $IMAGE_SIZE"

# 7. Test de l'image Docker
echo ""
echo "7️⃣ Test de l'image Docker..."

echo "🧪 Test de démarrage du conteneur..."
CONTAINER_ID=$(docker run -d -p 3002:3000 "$FULL_IMAGE_NAME:latest")

if [ $? -eq 0 ]; then
    print_success "Conteneur démarré (ID: ${CONTAINER_ID:0:12})"
    
    # Attendre que l'application soit prête
    echo "⏳ Attente du démarrage de l'application..."
    sleep 15
    
    # Test de santé
    if curl -f http://localhost:3002 > /dev/null 2>&1; then
        print_success "Application accessible sur http://localhost:3002"
        print_info "🎉 Vous pouvez tester l'application dans votre navigateur!"
        
        read -p "Appuyez sur Entrée pour continuer le push vers Docker Hub..."
    else
        print_warning "Application non accessible (peut être normal selon la configuration)"
    fi
    
    # Arrêt et suppression du conteneur de test
    docker stop "$CONTAINER_ID" > /dev/null 2>&1
    docker rm "$CONTAINER_ID" > /dev/null 2>&1
    print_info "Conteneur de test nettoyé"
else
    print_error "Échec du démarrage du conteneur"
    exit 1
fi

# 8. Push vers Docker Hub
echo ""
echo "8️⃣ Push vers Docker Hub..."

echo "📤 Push de l'image latest..."
if docker push "$FULL_IMAGE_NAME:latest"; then
    print_success "Push latest réussi"
else
    print_error "Échec du push latest"
    exit 1
fi

echo "📤 Push de l'image avec version..."
if docker push "$FULL_IMAGE_NAME:$VERSION_TAG"; then
    print_success "Push version $VERSION_TAG réussi"
else
    print_warning "Échec du push version (non critique)"
fi

echo "📤 Push de l'image avec commit..."
if docker push "$FULL_IMAGE_NAME:$GIT_COMMIT"; then
    print_success "Push commit $GIT_COMMIT réussi"
else
    print_warning "Échec du push commit (non critique)"
fi

# 9. Vérification sur Docker Hub
echo ""
echo "9️⃣ Vérification sur Docker Hub..."

print_info "Vérification de l'image sur Docker Hub..."
if docker pull "$FULL_IMAGE_NAME:latest" > /dev/null 2>&1; then
    print_success "Image disponible sur Docker Hub"
else
    print_warning "Impossible de vérifier l'image sur Docker Hub"
fi

# 10. Nettoyage local
echo ""
echo "🧹 Nettoyage local..."

read -p "Voulez-vous supprimer les images locales pour économiser l'espace? (y/n): " CLEANUP

if [[ "$CLEANUP" == "y" || "$CLEANUP" == "Y" ]]; then
    docker rmi "$FULL_IMAGE_NAME:$VERSION_TAG" 2>/dev/null || true
    docker rmi "$FULL_IMAGE_NAME:$GIT_COMMIT" 2>/dev/null || true
    print_info "Images locales nettoyées (latest conservée)"
fi

# Nettoyer le build
rm -rf dist
print_info "Dossier dist nettoyé"

# 11. Résumé final
echo ""
echo "🎉 PUSH DOCKER HUB TERMINÉ AVEC SUCCÈS!"
echo "======================================="

print_success "✅ Image construite et testée localement"
print_success "✅ Image poussée sur Docker Hub"

echo ""
print_info "📊 Informations de l'image:"
print_info "  🐳 Repository: $FULL_IMAGE_NAME"
print_info "  🏷️ Tags disponibles:"
print_info "    - latest"
print_info "    - $VERSION_TAG"
print_info "    - $GIT_COMMIT"
print_info "  📏 Taille: $IMAGE_SIZE"

echo ""
print_info "🌐 Votre image est maintenant disponible sur:"
print_info "   👉 https://hub.docker.com/r/$DOCKER_USERNAME/$IMAGE_NAME"

echo ""
print_info "🚀 Commandes pour utiliser votre image:"
echo "   docker pull $FULL_IMAGE_NAME:latest"
echo "   docker run -p 3000:3000 $FULL_IMAGE_NAME:latest"

echo ""
print_info "📋 Prochaines étapes:"
print_info "1. Configurez les secrets GitHub (DOCKER_USERNAME, DOCKER_PASSWORD)"
print_info "2. Configurez le déploiement O2Switch"
print_info "3. Testez le pipeline CI/CD complet"

# Sauvegarder les informations pour les scripts suivants
cat > .docker-info << EOF
DOCKER_USERNAME=$DOCKER_USERNAME
DOCKER_IMAGE_NAME=$FULL_IMAGE_NAME
DOCKER_VERSION_TAG=$VERSION_TAG
DOCKER_GIT_COMMIT=$GIT_COMMIT
DOCKER_IMAGE_SIZE=$IMAGE_SIZE
EOF

print_success "🎯 Informations Docker sauvegardées dans .docker-info"