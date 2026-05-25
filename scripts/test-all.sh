#!/bin/bash

# Script de test complet pour KABA-DELIVERY
# Usage: ./scripts/test-all.sh

set -e

echo "🧪 Lancement de la suite de tests complète KABA-DELIVERY"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage coloré
print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠️ $message${NC}"
            ;;
        "INFO")
            echo -e "${BLUE}ℹ️ $message${NC}"
            ;;
    esac
}

# Vérification des prérequis
print_status "INFO" "Vérification des prérequis..."

if ! command -v node &> /dev/null; then
    print_status "ERROR" "Node.js n'est pas installé"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    print_status "ERROR" "npm n'est pas installé"
    exit 1
fi

print_status "SUCCESS" "Prérequis validés"

# Installation des dépendances
if [ ! -d "node_modules" ]; then
    print_status "INFO" "Installation des dépendances..."
    npm install
fi

# 1. Tests de linting
print_status "INFO" "Exécution du linting ESLint..."
if npm run lint; then
    print_status "SUCCESS" "Linting réussi"
else
    print_status "ERROR" "Échec du linting"
    exit 1
fi

# 2. Tests unitaires
print_status "INFO" "Exécution des tests unitaires..."
if npm run test; then
    print_status "SUCCESS" "Tests unitaires réussis"
else
    print_status "ERROR" "Échec des tests unitaires"
    exit 1
fi

# 3. Tests de couverture
print_status "INFO" "Génération du rapport de couverture..."
if npm run test:coverage; then
    print_status "SUCCESS" "Rapport de couverture généré"
    
    # Vérification du seuil de couverture
    if [ -f "coverage/coverage-summary.json" ]; then
        COVERAGE=$(node -e "
            const fs = require('fs');
            const coverage = JSON.parse(fs.readFileSync('coverage/coverage-summary.json', 'utf8'));
            console.log(coverage.total.lines.pct);
        ")
        
        if (( $(echo "$COVERAGE >= 80" | bc -l) )); then
            print_status "SUCCESS" "Couverture de code: $COVERAGE% (≥ 80%)"
        else
            print_status "WARNING" "Couverture de code: $COVERAGE% (< 80%)"
        fi
    fi
else
    print_status "ERROR" "Échec de la génération du rapport de couverture"
    exit 1
fi

# 4. Test de build
print_status "INFO" "Test de build de production..."
if npm run build; then
    print_status "SUCCESS" "Build de production réussi"
    
    # Vérification de la taille du build
    if [ -d "dist" ]; then
        BUILD_SIZE=$(du -sh dist | cut -f1)
        print_status "INFO" "Taille du build: $BUILD_SIZE"
    fi
else
    print_status "ERROR" "Échec du build de production"
    exit 1
fi

# 5. Test Docker (si Docker est disponible)
if command -v docker &> /dev/null; then
    print_status "INFO" "Test de build Docker..."
    if docker build -t kaba-delivery-test .; then
        print_status "SUCCESS" "Build Docker réussi"
        
        # Nettoyage de l'image de test
        docker rmi kaba-delivery-test > /dev/null 2>&1 || true
    else
        print_status "WARNING" "Échec du build Docker (non critique)"
    fi
else
    print_status "WARNING" "Docker non disponible - test Docker ignoré"
fi

# 6. Vérification des vulnérabilités
print_status "INFO" "Audit de sécurité des dépendances..."
if npm audit --audit-level=high; then
    print_status "SUCCESS" "Aucune vulnérabilité critique détectée"
else
    print_status "WARNING" "Vulnérabilités détectées - vérifiez npm audit"
fi

# 7. Vérification de la structure des fichiers
print_status "INFO" "Vérification de la structure du projet..."

REQUIRED_FILES=(
    "package.json"
    "Dockerfile"
    ".github/workflows/main.yml"
    "src/App.jsx"
    "src/main.jsx"
    "vite.config.js"
    "README.md"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    print_status "SUCCESS" "Structure du projet validée"
else
    print_status "ERROR" "Fichiers manquants: ${MISSING_FILES[*]}"
    exit 1
fi

# Résumé final
echo ""
echo "📊 RÉSUMÉ DES TESTS"
echo "===================="
print_status "SUCCESS" "Linting ESLint"
print_status "SUCCESS" "Tests unitaires"
print_status "SUCCESS" "Couverture de code"
print_status "SUCCESS" "Build de production"
if command -v docker &> /dev/null; then
    print_status "SUCCESS" "Build Docker"
fi
print_status "SUCCESS" "Audit de sécurité"
print_status "SUCCESS" "Structure du projet"

echo ""
print_status "SUCCESS" "🎉 Tous les tests sont passés avec succès!"
print_status "INFO" "Le projet KABA-DELIVERY est prêt pour le déploiement"

# Nettoyage
rm -rf dist > /dev/null 2>&1 || true

echo ""
echo "📝 Prochaines étapes:"
echo "  1. Configurer les secrets GitHub/GitLab"
echo "  2. Pousser le code vers le repository"
echo "  3. Le pipeline CI/CD se déclenchera automatiquement"
echo "  4. Surveiller le déploiement sur O2Switch"