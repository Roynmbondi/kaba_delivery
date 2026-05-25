#!/bin/bash

# Script d'aide pour la configuration GitHub - KABA-DELIVERY
# Ce script vous guide dans la configuration

echo "🚀 Configuration GitHub pour KABA-DELIVERY"
echo "=========================================="

# Vérification de Git
if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé. Veuillez installer Git d'abord."
    exit 1
fi

echo "✅ Git détecté: $(git --version)"

# Configuration Git si nécessaire
echo ""
echo "📝 Configuration Git locale"
echo "Votre nom d'utilisateur Git actuel: $(git config user.name || echo 'Non configuré')"
echo "Votre email Git actuel: $(git config user.email || echo 'Non configuré')"

read -p "Voulez-vous configurer/modifier votre nom d'utilisateur Git? (y/n): " configure_name
if [[ $configure_name == "y" || $configure_name == "Y" ]]; then
    read -p "Entrez votre nom complet: " git_name
    git config --global user.name "$git_name"
    echo "✅ Nom configuré: $git_name"
fi

read -p "Voulez-vous configurer/modifier votre email Git? (y/n): " configure_email
if [[ $configure_email == "y" || $configure_email == "Y" ]]; then
    read -p "Entrez votre email: " git_email
    git config --global user.email "$git_email"
    echo "✅ Email configuré: $git_email"
fi

echo ""
echo "📋 ÉTAPES À SUIVRE MANUELLEMENT:"
echo ""
echo "1️⃣ CRÉER LE REPOSITORY GITHUB:"
echo "   - Aller sur https://github.com"
echo "   - Cliquer sur 'New repository'"
echo "   - Nom: kaba-delivery"
echo "   - Description: Application de livraison KABA-DELIVERY - AFRIQ-LOGISTIX"
echo "   - Visibilité: Private (recommandé)"
echo "   - NE PAS initialiser avec README (nous avons déjà les fichiers)"
echo ""

echo "2️⃣ COPIER L'URL DU REPOSITORY:"
echo "   Après création, copier l'URL HTTPS ou SSH"
echo "   Exemple: https://github.com/votre-username/kaba-delivery.git"
echo ""

read -p "Avez-vous créé le repository et copié l'URL? (y/n): " repo_created
if [[ $repo_created == "y" || $repo_created == "Y" ]]; then
    read -p "Collez l'URL du repository: " repo_url
    
    echo ""
    echo "🔧 Configuration du repository local..."
    
    # Initialiser Git si nécessaire
    if [ ! -d ".git" ]; then
        git init
        echo "✅ Repository Git initialisé"
    fi
    
    # Ajouter l'origine
    git remote remove origin 2>/dev/null || true
    git remote add origin "$repo_url"
    echo "✅ Remote origin configuré: $repo_url"
    
    # Créer la branche main si nécessaire
    git branch -M main
    
    echo ""
    echo "📦 Préparation des fichiers pour le commit..."
    git add .
    git status
    
    echo ""
    read -p "Voulez-vous faire le commit initial? (y/n): " do_commit
    if [[ $do_commit == "y" || $do_commit == "Y" ]]; then
        git commit -m "feat: initial commit KABA-DELIVERY project

- Complete DevOps infrastructure with CI/CD pipeline
- React application for delivery management
- Docker containerization with multi-stage build
- SonarQube integration for code quality
- ELK stack + Prometheus/Grafana monitoring
- Security scanning with Trivy
- Automated deployment to O2Switch
- Comprehensive documentation

Implements all requirements for AFRIQ-LOGISTIX delivery platform."
        
        echo "✅ Commit initial créé"
        
        echo ""
        read -p "Voulez-vous pousser vers GitHub maintenant? (y/n): " do_push
        if [[ $do_push == "y" || $do_push == "Y" ]]; then
            echo "🚀 Push vers GitHub..."
            git push -u origin main
            
            if [ $? -eq 0 ]; then
                echo "✅ Code poussé avec succès vers GitHub!"
                echo ""
                echo "🌐 Votre repository: $repo_url"
            else
                echo "❌ Erreur lors du push. Vérifiez vos permissions GitHub."
            fi
        fi
    fi
else
    echo "⏸️ Veuillez d'abord créer le repository GitHub, puis relancer ce script."
fi

echo ""
echo "📋 PROCHAINES ÉTAPES:"
echo "1. Configurer les secrets GitHub (voir instructions ci-dessous)"
echo "2. Créer les branches develop et feature/api-delivery"
echo "3. Configurer la protection des branches"
echo "4. Tester le pipeline CI/CD"
echo ""
echo "📖 Consultez docs/DEPLOYMENT.md pour les détails complets"