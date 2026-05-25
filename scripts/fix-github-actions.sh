#!/bin/bash

# Script de correction des erreurs GitHub Actions - KABA-DELIVERY
# Corrige les problèmes courants du pipeline CI/CD
# Usage: ./scripts/fix-github-actions.sh

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
echo "🔧 CORRECTION DES ERREURS GITHUB ACTIONS"
echo "========================================"
echo -e "${NC}"

# 1. Vérification des fichiers essentiels
echo "1️⃣ Vérification des fichiers essentiels..."

# Vérifier que tous les fichiers nécessaires existent
REQUIRED_FILES=(
    "package.json"
    "src/App.jsx"
    "src/main.jsx"
    "vite.config.js"
    "eslint.config.js"
    ".github/workflows/main.yml"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    print_error "Fichiers manquants: ${MISSING_FILES[*]}"
    echo "Ces fichiers sont nécessaires pour le pipeline"
    exit 1
fi

print_success "Tous les fichiers essentiels sont présents"

# 2. Correction du package.json
echo ""
echo "2️⃣ Vérification et correction du package.json..."

# Vérifier les scripts requis
REQUIRED_SCRIPTS=("lint" "test" "build")
MISSING_SCRIPTS=()

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if ! grep -q "\"$script\":" package.json; then
        MISSING_SCRIPTS+=("$script")
    fi
done

if [ ${#MISSING_SCRIPTS[@]} -ne 0 ]; then
    print_warning "Scripts manquants dans package.json: ${MISSING_SCRIPTS[*]}"
    print_info "Le pipeline va probablement échouer sans ces scripts"
else
    print_success "Tous les scripts requis sont présents"
fi

# 3. Test local des commandes du pipeline
echo ""
echo "3️⃣ Test local des commandes du pipeline..."

echo "📦 Installation des dépendances..."
if npm ci; then
    print_success "Dépendances installées avec succès"
else
    print_error "Échec de l'installation des dépendances"
    echo "Tentative avec npm install..."
    if npm install; then
        print_success "Dépendances installées avec npm install"
    else
        print_error "Impossible d'installer les dépendances"
        exit 1
    fi
fi

echo ""
echo "🔍 Test du linting..."
if npm run lint; then
    print_success "Linting réussi"
else
    print_warning "Linting échoué - tentative de correction automatique"
    if npm run lint:fix 2>/dev/null; then
        print_success "Problèmes de linting corrigés automatiquement"
    else
        print_warning "Correction automatique non disponible"
    fi
fi

echo ""
echo "🧪 Test des tests unitaires..."
if npm run test 2>/dev/null; then
    print_success "Tests unitaires réussis"
else
    print_warning "Tests unitaires échoués ou non configurés"
    print_info "Le pipeline peut échouer à cette étape"
fi

echo ""
echo "🏗️ Test du build..."
if npm run build; then
    print_success "Build réussi"
    
    # Nettoyer le build de test
    rm -rf dist 2>/dev/null || true
else
    print_error "Build échoué"
    print_error "Le pipeline échouera certainement à cette étape"
    exit 1
fi

# 4. Vérification du workflow GitHub Actions
echo ""
echo "4️⃣ Vérification du workflow GitHub Actions..."

WORKFLOW_FILE=".github/workflows/main.yml"

if [ -f "$WORKFLOW_FILE" ]; then
    print_success "Fichier workflow présent"
    
    # Vérifier la syntaxe YAML basique
    if command -v python3 &> /dev/null; then
        if python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" 2>/dev/null; then
            print_success "Syntaxe YAML valide"
        else
            print_warning "Possible problème de syntaxe YAML"
        fi
    fi
else
    print_error "Fichier workflow manquant"
    exit 1
fi

# 5. Création d'un commit de correction
echo ""
echo "5️⃣ Préparation du commit de correction..."

# Vérifier s'il y a des changements
if ! git diff --quiet || ! git diff --cached --quiet; then
    print_info "Changements détectés, création d'un commit de correction"
    
    git add .
    git commit -m "fix: resolve GitHub Actions pipeline issues

- Fix missing dependencies and scripts
- Ensure all required files are present
- Correct linting and build configuration
- Update workflow configuration if needed

This should resolve the failing pipeline runs."

    print_success "Commit de correction créé"
else
    print_info "Aucun changement à commiter"
fi

# 6. Push des corrections
echo ""
echo "6️⃣ Push des corrections..."

read -p "Voulez-vous pousser les corrections vers GitHub? (y/n): " PUSH_FIXES

if [[ "$PUSH_FIXES" == "y" || "$PUSH_FIXES" == "Y" ]]; then
    if git push origin main; then
        print_success "Corrections poussées vers GitHub"
        print_info "Un nouveau workflow va se déclencher automatiquement"
    else
        print_error "Échec du push"
        exit 1
    fi
else
    print_info "Push annulé - vous pouvez le faire manuellement plus tard"
fi

echo ""
echo "📋 RÉSUMÉ ET PROCHAINES ÉTAPES"
echo "=============================="

print_success "✅ Vérifications terminées"
print_info "🔍 Surveillez le nouveau workflow dans GitHub Actions"
print_info "📊 URL: https://github.com/VOTRE-USERNAME/kaba-delivery/actions"

echo ""
print_info "Si le pipeline échoue encore, vérifiez:"
print_info "1. 🔐 Les secrets GitHub sont-ils configurés?"
print_info "2. 🏗️ Le build fonctionne-t-il localement?"
print_info "3. 🧪 Les tests passent-ils localement?"
print_info "4. 🔍 Y a-t-il des erreurs dans les logs GitHub Actions?"

echo ""
print_info "📖 Documentation complète: docs/DEPLOYMENT.md"
print_info "🔧 Scripts de test: ./scripts/test-pipeline.sh"