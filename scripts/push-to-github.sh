#!/bin/bash

# Script de push vers GitHub avec création des branches - KABA-DELIVERY
# Usage: ./scripts/push-to-github.sh [repository-url]

set -e

echo "🚀 Push KABA-DELIVERY vers GitHub"
echo "================================="

# Vérification de Git
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

# URL du repository
REPO_URL=$1
if [ -z "$REPO_URL" ]; then
    echo "📝 URL du repository non fournie"
    read -p "Entrez l'URL de votre repository GitHub: " REPO_URL
fi

if [ -z "$REPO_URL" ]; then
    echo "❌ URL du repository requise"
    exit 1
fi

echo "🔗 Repository: $REPO_URL"

# Vérification du statut Git
if [ ! -d ".git" ]; then
    echo "📦 Initialisation du repository Git..."
    git init
fi

# Configuration du remote
echo "🔧 Configuration du remote origin..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Vérification des fichiers
echo "📋 Vérification des fichiers du projet..."
REQUIRED_FILES=(
    "package.json"
    "Dockerfile"
    ".github/workflows/main.yml"
    "src/App.jsx"
    "README.md"
    "PROJET-COMPLET.md"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -ne 0 ]; then
    echo "❌ Fichiers manquants: ${MISSING_FILES[*]}"
    echo "Veuillez vous assurer que tous les fichiers du projet sont présents"
    exit 1
fi

echo "✅ Tous les fichiers requis sont présents"

# Ajout des fichiers
echo "📦 Ajout des fichiers au staging..."
git add .

# Vérification du statut
echo "📊 Statut Git:"
git status --short

# Commit
echo ""
read -p "Voulez-vous créer le commit initial? (y/n): " do_commit
if [[ $do_commit == "y" || $do_commit == "Y" ]]; then
    echo "💾 Création du commit initial..."
    git commit -m "feat: initial commit KABA-DELIVERY project

🚚 Complete DevOps infrastructure for delivery management platform

Features implemented:
- ✅ React application for delivery tracking and management
- ✅ Docker containerization with multi-stage build
- ✅ Complete CI/CD pipeline with GitHub Actions
- ✅ SonarQube integration for code quality (>80% coverage)
- ✅ Security scanning with Trivy
- ✅ Automated deployment to O2Switch
- ✅ ELK stack for log management
- ✅ Prometheus + Grafana monitoring with alerts
- ✅ Comprehensive documentation and scripts

Architecture:
- Frontend: React 18 + Vite
- Containerization: Docker with non-root user
- CI/CD: 6-stage pipeline (Lint/Test/Quality/Security/Build/Deploy)
- Monitoring: ELK + Prometheus/Grafana
- Security: Trivy scans, secret management, Quality Gates

Developed for AFRIQ-LOGISTIX S.A. - Douala, Cameroun
Implements all requirements for the KABA-DELIVERY platform."

    echo "✅ Commit créé avec succès"
else
    echo "⏸️ Commit annulé"
    exit 0
fi

# Création de la branche main
echo "🌿 Configuration de la branche main..."
git branch -M main

# Push vers main
echo ""
read -p "Voulez-vous pousser vers GitHub maintenant? (y/n): " do_push
if [[ $do_push == "y" || $do_push == "Y" ]]; then
    echo "🚀 Push vers GitHub (branche main)..."
    
    if git push -u origin main; then
        echo "✅ Push réussi vers la branche main!"
    else
        echo "❌ Erreur lors du push"
        echo "Vérifiez:"
        echo "  - Vos permissions GitHub"
        echo "  - L'URL du repository"
        echo "  - Votre authentification Git"
        exit 1
    fi
else
    echo "⏸️ Push annulé"
    exit 0
fi

# Création des branches additionnelles
echo ""
read -p "Voulez-vous créer les branches develop et feature/api-delivery? (y/n): " create_branches
if [[ $create_branches == "y" || $create_branches == "Y" ]]; then
    echo "🌿 Création de la branche develop..."
    git checkout -b develop
    git push -u origin develop
    
    echo "🌿 Création de la branche feature/api-delivery..."
    git checkout -b feature/api-delivery
    git push -u origin feature/api-delivery
    
    # Retour sur main
    git checkout main
    
    echo "✅ Branches créées avec succès:"
    echo "  - main (branche principale)"
    echo "  - develop (branche de développement)"
    echo "  - feature/api-delivery (branche de fonctionnalité)"
fi

# Affichage des informations finales
echo ""
echo "🎉 PUSH TERMINÉ AVEC SUCCÈS!"
echo "============================"
echo ""
echo "📊 Repository: $REPO_URL"
echo "🌿 Branches créées:"
git branch -a | grep -E "(main|develop|feature)" || echo "  - main"
echo ""
echo "📋 PROCHAINES ÉTAPES:"
echo "1. 🔐 Configurer les secrets GitHub (voir scripts/configure-secrets.md)"
echo "2. 🛡️ Configurer la protection des branches"
echo "3. 🧪 Tester le pipeline CI/CD"
echo "4. 📊 Configurer le monitoring"
echo ""
echo "📖 Documentation complète: docs/DEPLOYMENT.md"
echo "🎯 Résumé du projet: PROJET-COMPLET.md"
echo ""
echo "🌐 Votre repository est maintenant disponible sur GitHub!"