#!/bin/bash

# Script de validation du pipeline GitHub Actions - KABA-DELIVERY
# Vérifie que tous les fichiers et configurations sont corrects
# Usage: ./scripts/validate-pipeline.sh

set -e

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
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
echo "🔍 VALIDATION DU PIPELINE KABA-DELIVERY"
echo "======================================="
echo -e "${NC}"

ERRORS=0
WARNINGS=0

# Fonction pour incrémenter les erreurs
add_error() {
    ((ERRORS++))
    print_error "$1"
}

add_warning() {
    ((WARNINGS++))
    print_warning "$1"
}

# 1. Vérification des fichiers essentiels
echo "📁 Vérification des fichiers essentiels..."

REQUIRED_FILES=(
    "package.json"
    "Dockerfile"
    ".github/workflows/main.yml"
    "src/App.jsx"
    "src/main.jsx"
    "vite.config.js"
    "eslint.config.js"
    "sonar-project.properties"
    ".gitignore"
    ".dockerignore"
    "README.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file"
    else
        add_error "Fichier manquant: $file"
    fi
done

# 2. Vérification du package.json
echo ""
echo "📦 Vérification du package.json..."

if [ -f "package.json" ]; then
    # Vérification des scripts requis
    REQUIRED_SCRIPTS=("dev" "build" "test" "lint" "test:coverage")
    
    for script in "${REQUIRED_SCRIPTS[@]}"; do
        if grep -q "\"$script\":" package.json; then
            print_success "Script '$script' présent"
        else
            add_error "Script manquant dans package.json: $script"
        fi
    done
    
    # Vérification des dépendances critiques
    REQUIRED_DEPS=("react" "react-dom" "vite")
    
    for dep in "${REQUIRED_DEPS[@]}"; do
        if grep -q "\"$dep\":" package.json; then
            print_success "Dépendance '$dep' présente"
        else
            add_error "Dépendance manquante: $dep"
        fi
    done
else
    add_error "package.json non trouvé"
fi

# 3. Vérification du Dockerfile
echo ""
echo "🐳 Vérification du Dockerfile..."

if [ -f "Dockerfile" ]; then
    # Vérifications de sécurité
    if grep -q "USER.*[^root]" Dockerfile; then
        print_success "Utilisateur non-root configuré"
    else
        add_warning "Utilisateur non-root non détecté dans le Dockerfile"
    fi
    
    if grep -q "FROM.*node.*alpine" Dockerfile; then
        print_success "Image de base Alpine utilisée (optimisée)"
    else
        add_warning "Image de base non-Alpine détectée"
    fi
    
    if grep -q "EXPOSE" Dockerfile; then
        print_success "Port exposé configuré"
    else
        add_warning "Aucun port exposé dans le Dockerfile"
    fi
else
    add_error "Dockerfile non trouvé"
fi

# 4. Vérification du workflow GitHub Actions
echo ""
echo "🔄 Vérification du workflow GitHub Actions..."

WORKFLOW_FILE=".github/workflows/main.yml"

if [ -f "$WORKFLOW_FILE" ]; then
    # Vérification des jobs requis
    REQUIRED_JOBS=("lint-and-test" "code-quality" "security-scan" "build-and-push")
    
    for job in "${REQUIRED_JOBS[@]}"; do
        if grep -q "$job:" "$WORKFLOW_FILE"; then
            print_success "Job '$job' présent"
        else
            add_error "Job manquant dans le workflow: $job"
        fi
    done
    
    # Vérification des secrets utilisés
    REQUIRED_SECRETS=("DOCKER_USERNAME" "DOCKER_PASSWORD" "SONAR_TOKEN")
    
    for secret in "${REQUIRED_SECRETS[@]}"; do
        if grep -q "\${{ secrets\.$secret }}" "$WORKFLOW_FILE"; then
            print_success "Secret '$secret' utilisé"
        else
            add_warning "Secret '$secret' non utilisé dans le workflow"
        fi
    done
else
    add_error "Workflow GitHub Actions non trouvé"
fi

# 5. Vérification de la configuration SonarQube
echo ""
echo "🔍 Vérification de la configuration SonarQube..."

if [ -f "sonar-project.properties" ]; then
    if grep -q "sonar.projectKey" sonar-project.properties; then
        print_success "Clé de projet SonarQube configurée"
    else
        add_error "sonar.projectKey manquant"
    fi
    
    if grep -q "sonar.sources" sonar-project.properties; then
        print_success "Sources SonarQube configurées"
    else
        add_warning "sonar.sources non configuré"
    fi
else
    add_error "sonar-project.properties non trouvé"
fi

# 6. Vérification de la structure des composants
echo ""
echo "⚛️ Vérification de la structure React..."

COMPONENT_DIR="src/components"
if [ -d "$COMPONENT_DIR" ]; then
    REQUIRED_COMPONENTS=("Header.jsx" "Sidebar.jsx" "RecipeList.jsx" "RecipeCard.jsx")
    
    for component in "${REQUIRED_COMPONENTS[@]}"; do
        if [ -f "$COMPONENT_DIR/$component" ]; then
            print_success "Composant '$component' présent"
        else
            add_warning "Composant manquant: $component"
        fi
    done
else
    add_error "Dossier src/components non trouvé"
fi

# 7. Vérification des tests
echo ""
echo "🧪 Vérification des tests..."

if [ -f "src/App.test.jsx" ]; then
    print_success "Tests principaux présents"
else
    add_warning "Tests principaux manquants (src/App.test.jsx)"
fi

if [ -f "src/test/setup.js" ]; then
    print_success "Configuration des tests présente"
else
    add_warning "Configuration des tests manquante"
fi

# 8. Vérification de la configuration Vite
echo ""
echo "⚡ Vérification de la configuration Vite..."

if [ -f "vite.config.js" ]; then
    if grep -q "test:" vite.config.js; then
        print_success "Configuration des tests Vite présente"
    else
        add_warning "Configuration des tests manquante dans vite.config.js"
    fi
else
    add_error "vite.config.js non trouvé"
fi

# 9. Vérification des scripts d'automatisation
echo ""
echo "🔧 Vérification des scripts d'automatisation..."

SCRIPT_DIR="scripts"
if [ -d "$SCRIPT_DIR" ]; then
    SCRIPTS=("deploy.sh" "monitoring-setup.sh" "start-dev.sh")
    
    for script in "${SCRIPTS[@]}"; do
        if [ -f "$SCRIPT_DIR/$script" ]; then
            if [ -x "$SCRIPT_DIR/$script" ]; then
                print_success "Script '$script' présent et exécutable"
            else
                add_warning "Script '$script' présent mais non exécutable"
            fi
        else
            add_warning "Script manquant: $script"
        fi
    done
else
    add_warning "Dossier scripts/ non trouvé"
fi

# 10. Vérification de la documentation
echo ""
echo "📚 Vérification de la documentation..."

DOC_DIR="docs"
if [ -d "$DOC_DIR" ]; then
    DOCS=("ARCHITECTURE.md" "DEPLOYMENT.md")
    
    for doc in "${DOCS[@]}"; do
        if [ -f "$DOC_DIR/$doc" ]; then
            print_success "Documentation '$doc' présente"
        else
            add_warning "Documentation manquante: $doc"
        fi
    done
else
    add_warning "Dossier docs/ non trouvé"
fi

# Résumé final
echo ""
echo "📊 RÉSUMÉ DE LA VALIDATION"
echo "=========================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "🎉 Validation parfaite ! Aucun problème détecté."
elif [ $ERRORS -eq 0 ]; then
    print_warning "✅ Validation réussie avec $WARNINGS avertissement(s)."
    print_info "Les avertissements n'empêchent pas le fonctionnement du pipeline."
else
    print_error "❌ Validation échouée avec $ERRORS erreur(s) et $WARNINGS avertissement(s)."
    print_error "Corrigez les erreurs avant de déployer le pipeline."
fi

echo ""
print_info "📋 Statistiques:"
print_info "   - Erreurs critiques: $ERRORS"
print_info "   - Avertissements: $WARNINGS"

if [ $ERRORS -eq 0 ]; then
    echo ""
    print_success "🚀 Votre pipeline est prêt pour GitHub Actions !"
    print_info "Prochaines étapes:"
    print_info "1. Configurer les secrets GitHub"
    print_info "2. Pousser le code vers GitHub"
    print_info "3. Surveiller l'exécution du pipeline"
    
    exit 0
else
    echo ""
    print_error "🛠️ Corrigez les erreurs avant de continuer."
    exit 1
fi