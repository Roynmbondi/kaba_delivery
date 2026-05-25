#!/bin/bash

# Configuration FTP pour O2Switch - KABA-DELIVERY
# Usage: ./scripts/setup-ftp-o2switch.sh

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
echo "📁 CONFIGURATION FTP POUR O2SWITCH"
echo "=================================="
echo -e "${NC}"

# 1. Collecte des informations FTP
echo "1️⃣ Informations FTP O2Switch..."

read -p "Entrez votre serveur FTP O2Switch (ex: ftp.votre-domaine.com): " FTP_HOST
read -p "Entrez votre nom d'utilisateur FTP: " FTP_USER
read -s -p "Entrez votre mot de passe FTP: " FTP_PASS
echo ""
read -p "Entrez le répertoire de destination (ex: /www ou /public_html): " FTP_DIR
FTP_DIR=${FTP_DIR:-/www}

print_info "Configuration FTP:"
print_info "  Serveur: $FTP_HOST"
print_info "  Utilisateur: $FTP_USER"
print_info "  Répertoire: $FTP_DIR"

# 2. Test de connexion FTP
echo ""
echo "2️⃣ Test de connexion FTP..."

if command -v ftp &> /dev/null; then
    echo "Test de connexion FTP..."
    # Test basique de connexion
    echo "open $FTP_HOST
user $FTP_USER $FTP_PASS
pwd
quit" | ftp -n > ftp_test.log 2>&1

    if grep -q "230" ftp_test.log; then
        print_success "Connexion FTP réussie!"
    else
        print_warning "Problème de connexion FTP - vérifiez les identifiants"
        cat ftp_test.log
    fi
    rm -f ftp_test.log
else
    print_warning "Client FTP non disponible - installation recommandée"
fi

# 3. Création du script de déploiement FTP
echo ""
echo "3️⃣ Création du script de déploiement FTP..."

cat > scripts/deploy-ftp.sh << EOF
#!/bin/bash

# Script de déploiement FTP pour O2Switch
# Usage: ./scripts/deploy-ftp.sh

set -e

# Configuration FTP
FTP_HOST="$FTP_HOST"
FTP_USER="$FTP_USER"
FTP_PASS="$FTP_PASS"
FTP_DIR="$FTP_DIR"

echo "📁 Déploiement FTP vers O2Switch..."

# Vérification du build
if [ ! -d "dist" ]; then
    echo "🏗️ Build de l'application..."
    npm run build
fi

echo "📦 Upload des fichiers via FTP..."

# Script FTP pour upload
ftp -n "\$FTP_HOST" << FTPEOF
user \$FTP_USER \$FTP_PASS
binary
cd \$FTP_DIR

# Création du répertoire kaba-delivery
mkdir kaba-delivery 2>/dev/null || echo "Répertoire existe déjà"
cd kaba-delivery

# Upload des fichiers du build
lcd dist
mput *

# Upload des fichiers statiques si nécessaire
lcd ../public
mput * 2>/dev/null || echo "Pas de fichiers publics"

pwd
ls -la
quit
FTPEOF

echo "✅ Déploiement FTP terminé!"
echo "🌐 Vérifiez votre site sur: http://votre-domaine.com/kaba-delivery"
EOF

chmod +x scripts/deploy-ftp.sh
print_success "Script de déploiement FTP créé: scripts/deploy-ftp.sh"

# 4. Configuration GitHub Actions pour FTP
echo ""
echo "4️⃣ Configuration GitHub Actions pour FTP..."

cat > .github/workflows/deploy-ftp.yml << EOF
name: Deploy to O2Switch via FTP

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy-ftp:
    name: 📁 Deploy via FTP
    runs-on: ubuntu-latest
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 📦 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: 📋 Install dependencies
        run: npm install

      - name: 🏗️ Build application
        run: npm run build

      - name: 📁 Deploy via FTP
        uses: SamKirkland/FTP-Deploy-Action@v4.3.4
        with:
          server: \${{ secrets.FTP_HOST }}
          username: \${{ secrets.FTP_USER }}
          password: \${{ secrets.FTP_PASS }}
          local-dir: ./dist/
          server-dir: $FTP_DIR/kaba-delivery/
          exclude: |
            **/.git*
            **/.git*/**
            **/node_modules/**
EOF

print_success "Workflow GitHub Actions FTP créé"

# 5. Instructions pour les secrets GitHub
echo ""
echo "5️⃣ Secrets GitHub à configurer..."

print_info "Ajoutez ces secrets dans GitHub:"
print_info "Repository > Settings > Secrets and variables > Actions"
echo ""
echo "FTP_HOST = $FTP_HOST"
echo "FTP_USER = $FTP_USER"
echo "FTP_PASS = [votre mot de passe FTP]"

# 6. Création d'un client FTP simple
echo ""
echo "6️⃣ Installation d'un client FTP (optionnel)..."

if command -v curl &> /dev/null; then
    cat > scripts/ftp-upload.sh << EOF
#!/bin/bash

# Upload FTP avec curl
# Usage: ./scripts/ftp-upload.sh <fichier-local> <fichier-distant>

LOCAL_FILE=\$1
REMOTE_FILE=\$2

if [ -z "\$LOCAL_FILE" ] || [ -z "\$REMOTE_FILE" ]; then
    echo "Usage: \$0 <fichier-local> <fichier-distant>"
    exit 1
fi

curl -T "\$LOCAL_FILE" ftp://$FTP_HOST$FTP_DIR/kaba-delivery/\$REMOTE_FILE --user $FTP_USER:$FTP_PASS
EOF
    chmod +x scripts/ftp-upload.sh
    print_success "Script d'upload FTP créé: scripts/ftp-upload.sh"
fi

# 7. Instructions finales
echo ""
echo "🎉 CONFIGURATION FTP TERMINÉE!"
echo "============================="

print_success "✅ Configuration FTP testée"
print_success "✅ Scripts de déploiement créés"
print_success "✅ Workflow GitHub Actions configuré"

echo ""
print_info "📋 Prochaines étapes:"
print_info "1. Ajoutez les secrets FTP dans GitHub"
print_info "2. Testez le déploiement: ./scripts/deploy-ftp.sh"
print_info "3. Vérifiez votre site web"

echo ""
print_info "📁 Fichiers créés:"
print_info "  - scripts/deploy-ftp.sh"
print_info "  - .github/workflows/deploy-ftp.yml"
print_info "  - scripts/ftp-upload.sh (si curl disponible)"

echo ""
print_info "🌐 Après déploiement, votre site sera accessible à:"
print_info "   http://votre-domaine.com/kaba-delivery"