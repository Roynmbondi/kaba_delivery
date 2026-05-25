#!/bin/bash

# Script de diagnostic Git pour KABA-DELIVERY
# Identifie les problèmes de push vers GitHub
# Usage: ./scripts/diagnose-git.sh

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
echo "🔍 DIAGNOSTIC GIT - KABA-DELIVERY"
echo "================================="
echo -e "${NC}"

# 1. Vérification de Git
echo "1️⃣ Vérification de Git..."
if command -v git &> /dev/null; then
    print_success "Git installé: $(git --version)"
else
    print_error "Git n'est pas installé"
    echo "Installez Git depuis: https://git-scm.com/"
    exit 1
fi

# 2. Vérification du repository Git
echo ""
echo "2️⃣ Vérification du repository local..."
if [ -d ".git" ]; then
    print_success "Repository Git initialisé"
else
    print_error "Repository Git non initialisé"
    echo "Solution: git init"
    exit 1
fi

# 3. Configuration Git
echo ""
echo "3️⃣ Configuration Git..."
GIT_USER=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -n "$GIT_USER" ]; then
    print_success "Nom d'utilisateur: $GIT_USER"
else
    print_error "Nom d'utilisateur Git non configuré"
    echo "Solution: git config --global user.name 'Votre Nom'"
fi

if [ -n "$GIT_EMAIL" ]; then
    print_success "Email: $GIT_EMAIL"
else
    print_error "Email Git non configuré"
    echo "Solution: git config --global user.email 'votre@email.com'"
fi

# 4. Vérification des remotes
echo ""
echo "4️⃣ Vérification des remotes..."
if git remote -v &>/dev/null; then
    REMOTES=$(git remote -v)
    if [ -n "$REMOTES" ]; then
        print_success "Remotes configurés:"
        echo "$REMOTES"
        
        # Vérification de l'origine
        if git remote get-url origin &>/dev/null; then
            ORIGIN_URL=$(git remote get-url origin)
            print_success "Origin configuré: $ORIGIN_URL"
        else
            print_error "Remote 'origin' non configuré"
        fi
    else
        print_error "Aucun remote configuré"
        echo "Solution: git remote add origin <URL_REPOSITORY>"
    fi
else
    print_error "Impossible de vérifier les remotes"
fi

# 5. Statut du repository
echo ""
echo "5️⃣ Statut du repository..."
echo "Statut Git:"
git status --porcelain | head -10

UNTRACKED=$(git status --porcelain | grep "^??" | wc -l)
MODIFIED=$(git status --porcelain | grep "^.M" | wc -l)
STAGED=$(git status --porcelain | grep "^M" | wc -l)

print_info "Fichiers non suivis: $UNTRACKED"
print_info "Fichiers modifiés: $MODIFIED"
print_info "Fichiers en staging: $STAGED"

# 6. Vérification des branches
echo ""
echo "6️⃣ Vérification des branches..."
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -n "$CURRENT_BRANCH" ]; then
    print_success "Branche actuelle: $CURRENT_BRANCH"
else
    print_warning "Aucune branche active (repository vide?)"
fi

# Liste des branches
BRANCHES=$(git branch -a 2>/dev/null || echo "")
if [ -n "$BRANCHES" ]; then
    print_info "Branches disponibles:"
    echo "$BRANCHES"
else
    print_warning "Aucune branche trouvée"
fi

# 7. Test de connectivité
echo ""
echo "7️⃣ Test de connectivité..."
if git remote get-url origin &>/dev/null; then
    ORIGIN_URL=$(git remote get-url origin)
    
    # Test de connectivité basique
    if [[ "$ORIGIN_URL" == https://* ]]; then
        DOMAIN=$(echo "$ORIGIN_URL" | sed 's|https://||' | cut -d'/' -f1)
        if ping -c 1 "$DOMAIN" &>/dev/null; then
            print_success "Connectivité réseau OK vers $DOMAIN"
        else
            print_warning "Problème de connectivité vers $DOMAIN"
        fi
    fi
    
    # Test d'authentification
    echo "Test d'authentification..."
    if git ls-remote origin &>/dev/null; then
        print_success "Authentification GitHub OK"
    else
        print_error "Échec de l'authentification GitHub"
        echo ""
        print_info "Solutions possibles:"
        echo "1. Vérifiez vos identifiants GitHub"
        echo "2. Configurez un token d'accès personnel"
        echo "3. Vérifiez les permissions du repository"
    fi
else
    print_warning "Aucun remote origin configuré pour tester la connectivité"
fi

# 8. Vérification des fichiers volumineux
echo ""
echo "8️⃣ Vérification des fichiers volumineux..."
LARGE_FILES=$(find . -type f -size +50M 2>/dev/null | grep -v ".git" | head -5)
if [ -n "$LARGE_FILES" ]; then
    print_warning "Fichiers volumineux détectés (>50MB):"
    echo "$LARGE_FILES"
    echo "GitHub limite les fichiers à 100MB"
else
    print_success "Aucun fichier volumineux détecté"
fi

# 9. Dernières tentatives de push
echo ""
echo "9️⃣ Historique des commits..."
if git log --oneline -5 &>/dev/null; then
    print_success "Derniers commits:"
    git log --oneline -5
else
    print_warning "Aucun commit trouvé"
    echo "Solution: Créer un commit initial"
    echo "git add ."
    echo "git commit -m 'Initial commit'"
fi

# 10. Recommandations
echo ""
echo "🔧 RECOMMANDATIONS"
echo "=================="

# Vérifier si on peut faire un push de test
if git remote get-url origin &>/dev/null && [ -n "$GIT_USER" ] && [ -n "$GIT_EMAIL" ]; then
    echo ""
    print_info "Configuration semble correcte. Tentative de diagnostic du push..."
    
    # Créer un commit de test si nécessaire
    if [ $UNTRACKED -gt 0 ] || [ $MODIFIED -gt 0 ]; then
        echo ""
        echo "📦 Préparation d'un commit de test..."
        echo "Voulez-vous créer un commit avec les fichiers actuels? (y/n)"
        read -r RESPONSE
        
        if [[ "$RESPONSE" == "y" || "$RESPONSE" == "Y" ]]; then
            git add .
            git commit -m "test: diagnostic commit for pipeline setup"
            print_success "Commit de test créé"
            
            echo ""
            echo "🚀 Tentative de push..."
            if git push -u origin main 2>&1; then
                print_success "Push réussi!"
            else
                print_error "Push échoué. Voir les détails ci-dessus."
            fi
        fi
    else
        echo ""
        echo "🚀 Tentative de push des commits existants..."
        if git push -u origin main 2>&1; then
            print_success "Push réussi!"
        else
            print_error "Push échoué. Voir les détails ci-dessus."
        fi
    fi
else
    echo ""
    print_warning "Configuration incomplète. Complétez d'abord:"
    
    if [ -z "$GIT_USER" ]; then
        echo "git config --global user.name 'Votre Nom'"
    fi
    
    if [ -z "$GIT_EMAIL" ]; then
        echo "git config --global user.email 'votre@email.com'"
    fi
    
    if ! git remote get-url origin &>/dev/null; then
        echo "git remote add origin <URL_REPOSITORY>"
    fi
fi

echo ""
print_info "📖 Pour plus d'aide, consultez: docs/DEPLOYMENT.md"