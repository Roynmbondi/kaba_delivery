#!/bin/bash

# Script de résolution des problèmes de push Git - KABA-DELIVERY
# Résout automatiquement les problèmes courants
# Usage: ./scripts/fix-git-push.sh

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
echo "🔧 RÉSOLUTION DES PROBLÈMES GIT - KABA-DELIVERY"
echo "==============================================="
echo -e "${NC}"

# 1. Vérification et initialisation Git
echo "1️⃣ Initialisation Git..."
if [ ! -d ".git" ]; then
    print_warning "Repository Git non initialisé"
    git init
    print_success "Repository Git initialisé"
else
    print_success "Repository Git déjà initialisé"
fi

# 2. Configuration Git
echo ""
echo "2️⃣ Configuration Git..."

GIT_USER=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -z "$GIT_USER" ]; then
    print_warning "Nom d'utilisateur Git non configuré"
    read -p "Entrez votre nom complet: " USER_NAME
    git config --global user.name "$USER_NAME"
    print_success "Nom configuré: $USER_NAME"
else
    print_success "Nom d'utilisateur: $GIT_USER"
fi

if [ -z "$GIT_EMAIL" ]; then
    print_warning "Email Git non configuré"
    read -p "Entrez votre email: " USER_EMAIL
    git config --global user.email "$USER_EMAIL"
    print_success "Email configuré: $USER_EMAIL"
else
    print_success "Email: $GIT_EMAIL"
fi

# 3. Configuration du remote
echo ""
echo "3️⃣ Configuration du remote GitHub..."

if ! git remote get-url origin &>/dev/null; then
    print_warning "Remote origin non configuré"
    echo ""
    echo "📋 Instructions pour créer le repository GitHub:"
    echo "1. Aller sur https://github.com"
    echo "2. Cliquer 'New repository'"
    echo "3. Nom: kaba-delivery"
    echo "4. Private (recommandé)"
    echo "5. NE PAS initialiser avec README"
    echo ""
    
    read -p "Avez-vous créé le repository GitHub? (y/n): " REPO_CREATED
    
    if [[ "$REPO_CREATED" == "y" || "$REPO_CREATED" == "Y" ]]; then
        read -p "Entrez l'URL du repository (ex: https://github.com/username/kaba-delivery.git): " REPO_URL
        
        if [ -n "$REPO_URL" ]; then
            git remote add origin "$REPO_URL"
            print_success "Remote origin configuré: $REPO_URL"
        else
            print_error "URL du repository requise"
            exit 1
        fi
    else
        print_error "Veuillez d'abord créer le repository GitHub"
        exit 1
    fi
else
    ORIGIN_URL=$(git remote get-url origin)
    print_success "Remote origin déjà configuré: $ORIGIN_URL"
fi

# 4. Préparation des fichiers
echo ""
echo "4️⃣ Préparation des fichiers..."

# Vérifier les fichiers essentiels
ESSENTIAL_FILES=("package.json" "src/App.jsx" "Dockerfile" ".github/workflows/main.yml")
MISSING_FILES=()

for file in "${ESSENTIAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    print_error "Fichiers essentiels manquants: ${MISSING_FILES[*]}"
    print_error "Assurez-vous d'être dans le bon répertoire du projet"
    exit 1
fi

print_success "Tous les fichiers essentiels sont présents"

# 5. Ajout des fichiers
echo ""
echo "5️⃣ Ajout des fichiers au staging..."

# Vérifier la taille des fichiers
echo "Vérification des fichiers volumineux..."
LARGE_FILES=$(find . -type f -size +50M 2>/dev/null | grep -v ".git" | head -5)
if [ -n "$LARGE_FILES" ]; then
    print_warning "Fichiers volumineux détectés:"
    echo "$LARGE_FILES"
    echo ""
    read -p "Continuer malgré les fichiers volumineux? (y/n): " CONTINUE
    if [[ "$CONTINUE" != "y" && "$CONTINUE" != "Y" ]]; then
        print_error "Supprimez ou ignorez les fichiers volumineux avant de continuer"
        exit 1
    fi
fi

git add .
print_success "Fichiers ajoutés au staging"

# Afficher le statut
echo ""
echo "📊 Statut Git:"
git status --short | head -10

# 6. Création du commit
echo ""
echo "6️⃣ Création du commit..."

# Vérifier s'il y a des changements à commiter
if git diff --cached --quiet; then
    print_warning "Aucun changement à commiter"
    
    # Vérifier s'il y a des commits existants
    if git log --oneline -1 &>/dev/null; then
        print_info "Des commits existent déjà"
    else
        print_error "Aucun commit trouvé et aucun changement à commiter"
        exit 1
    fi
else
    echo "Création du commit initial..."
    git commit -m "feat: initial commit KABA-DELIVERY project

🚚 Complete DevOps infrastructure for delivery management

Features:
- React application for delivery tracking
- Docker containerization with security
- Complete CI/CD pipeline with GitHub Actions
- SonarQube integration for code quality
- ELK stack + Prometheus/Grafana monitoring
- Security scanning and automated deployment
- Comprehensive documentation

Developed for AFRIQ-LOGISTIX S.A. - Douala, Cameroun"

    print_success "Commit initial créé"
fi

# 7. Configuration de la branche
echo ""
echo "7️⃣ Configuration de la branche..."

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ "$CURRENT_BRANCH" != "main" ]; then
    git branch -M main
    print_success "Branche renommée en 'main'"
else
    print_success "Branche 'main' déjà active"
fi

# 8. Test de connectivité
echo ""
echo "8️⃣ Test de connectivité GitHub..."

if git ls-remote origin &>/dev/null; then
    print_success "Connexion GitHub OK"
else
    print_error "Échec de la connexion GitHub"
    echo ""
    print_info "Solutions possibles:"
    echo "1. Vérifiez votre connexion Internet"
    echo "2. Vérifiez l'URL du repository"
    echo "3. Configurez l'authentification GitHub:"
    echo "   - Token d'accès personnel"
    echo "   - Clé SSH"
    echo ""
    
    read -p "Voulez-vous configurer un token d'accès GitHub? (y/n): " SETUP_TOKEN
    if [[ "$SETUP_TOKEN" == "y" || "$SETUP_TOKEN" == "Y" ]]; then
        echo ""
        echo "📋 Configuration du token GitHub:"
        echo "1. Aller sur https://github.com/settings/tokens"
        echo "2. 'Generate new token (classic)'"
        echo "3. Sélectionner les scopes: repo, workflow"
        echo "4. Copier le token généré"
        echo ""
        
        read -p "Entrez votre token GitHub: " GITHUB_TOKEN
        if [ -n "$GITHUB_TOKEN" ]; then
            # Modifier l'URL pour inclure le token
            ORIGIN_URL=$(git remote get-url origin)
            if [[ "$ORIGIN_URL" == https://github.com/* ]]; then
                NEW_URL=$(echo "$ORIGIN_URL" | sed "s|https://github.com/|https://$GITHUB_TOKEN@github.com/|")
                git remote set-url origin "$NEW_URL"
                print_success "Token configuré dans l'URL du remote"
            fi
        fi
    fi
fi

# 9. Push vers GitHub
echo ""
echo "9️⃣ Push vers GitHub..."

echo "🚀 Tentative de push..."
if git push -u origin main; then
    print_success "🎉 Push réussi vers GitHub!"
    
    ORIGIN_URL=$(git remote get-url origin | sed 's|https://.*@github.com/|https://github.com/|')
    echo ""
    print_success "🌐 Repository disponible: $ORIGIN_URL"
    
    # Création des branches additionnelles
    echo ""
    read -p "Voulez-vous créer les branches develop et feature/api-delivery? (y/n): " CREATE_BRANCHES
    if [[ "$CREATE_BRANCHES" == "y" || "$CREATE_BRANCHES" == "Y" ]]; then
        echo "🌿 Création des branches..."
        
        git checkout -b develop
        git push -u origin develop
        print_success "Branche 'develop' créée"
        
        git checkout -b feature/api-delivery
        git push -u origin feature/api-delivery
        print_success "Branche 'feature/api-delivery' créée"
        
        git checkout main
        print_success "Retour sur la branche 'main'"
    fi
    
else
    print_error "❌ Échec du push"
    echo ""
    print_info "Erreurs possibles:"
    echo "1. Problème d'authentification"
    echo "2. Repository n'existe pas"
    echo "3. Pas de permissions d'écriture"
    echo "4. Fichiers trop volumineux"
    echo ""
    
    # Diagnostic supplémentaire
    echo "🔍 Diagnostic supplémentaire:"
    echo "URL du remote: $(git remote get-url origin)"
    echo "Branche actuelle: $(git branch --show-current)"
    echo "Derniers commits:"
    git log --oneline -3 2>/dev/null || echo "Aucun commit"
    
    exit 1
fi

# 10. Instructions finales
echo ""
echo "📋 PROCHAINES ÉTAPES"
echo "==================="
print_success "✅ Code poussé sur GitHub avec succès!"
echo ""
print_info "1. 🔐 Configurer les secrets GitHub:"
print_info "   - Voir: scripts/configure-secrets.md"
print_info "   - Repository > Settings > Secrets and variables > Actions"
echo ""
print_info "2. 🛡️ Configurer la protection des branches:"
print_info "   - Repository > Settings > Branches"
print_info "   - Add rule pour 'main'"
echo ""
print_info "3. 🧪 Tester le pipeline:"
print_info "   - Faire un petit changement et push"
print_info "   - Surveiller dans Actions"
echo ""
print_info "4. 📊 Configurer le monitoring:"
print_info "   - Suivre docs/DEPLOYMENT.md"

echo ""
print_success "🎉 Configuration Git terminée avec succès!"