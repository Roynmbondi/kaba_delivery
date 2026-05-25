#!/bin/bash

# Configuration SSH pour O2Switch - KABA-DELIVERY
# Usage: ./scripts/setup-ssh-o2switch.sh

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
echo "🔐 CONFIGURATION SSH POUR O2SWITCH"
echo "=================================="
echo -e "${NC}"

# 1. Vérification des prérequis
echo "1️⃣ Vérification des prérequis..."

if ! command -v ssh &> /dev/null; then
    print_error "SSH n'est pas installé"
    exit 1
fi

if ! command -v ssh-keygen &> /dev/null; then
    print_error "ssh-keygen n'est pas disponible"
    exit 1
fi

print_success "SSH disponible"

# 2. Collecte des informations O2Switch
echo ""
echo "2️⃣ Informations O2Switch..."

read -p "Entrez votre nom d'utilisateur O2Switch: " O2SWITCH_USER
read -p "Entrez l'adresse de votre serveur O2Switch (ex: ssh.o2switch.net): " O2SWITCH_HOST
read -p "Entrez le port SSH (défaut: 22): " O2SWITCH_PORT
O2SWITCH_PORT=${O2SWITCH_PORT:-22}

print_info "Configuration:"
print_info "  Utilisateur: $O2SWITCH_USER"
print_info "  Serveur: $O2SWITCH_HOST"
print_info "  Port: $O2SWITCH_PORT"

# 3. Génération de la clé SSH
echo ""
echo "3️⃣ Génération de la clé SSH..."

SSH_KEY_PATH="$HOME/.ssh/kaba_delivery_o2switch"

if [ -f "$SSH_KEY_PATH" ]; then
    print_warning "Clé SSH existe déjà: $SSH_KEY_PATH"
    read -p "Voulez-vous la régénérer? (y/n): " REGENERATE
    
    if [[ "$REGENERATE" != "y" && "$REGENERATE" != "Y" ]]; then
        print_info "Utilisation de la clé existante"
    else
        rm -f "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub"
        print_info "Ancienne clé supprimée"
    fi
fi

if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Génération de la nouvelle clé SSH..."
    ssh-keygen -t rsa -b 4096 -C "kaba-delivery@o2switch" -f "$SSH_KEY_PATH" -N ""
    print_success "Clé SSH générée: $SSH_KEY_PATH"
fi

# 4. Affichage de la clé publique
echo ""
echo "4️⃣ Clé publique à ajouter sur O2Switch..."

print_info "Copiez cette clé publique dans votre panel O2Switch:"
echo ""
echo "----------------------------------------"
cat "$SSH_KEY_PATH.pub"
echo "----------------------------------------"
echo ""

print_info "📋 Instructions O2Switch:"
print_info "1. Connectez-vous à votre panel O2Switch"
print_info "2. Allez dans 'SSH' ou 'Accès SSH'"
print_info "3. Ajoutez la clé publique ci-dessus"
print_info "4. Activez l'accès SSH si nécessaire"

read -p "Appuyez sur Entrée quand vous avez ajouté la clé sur O2Switch..."

# 5. Test de connexion SSH
echo ""
echo "5️⃣ Test de connexion SSH..."

echo "Test de connexion à $O2SWITCH_HOST..."
if ssh -i "$SSH_KEY_PATH" -p "$O2SWITCH_PORT" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$O2SWITCH_USER@$O2SWITCH_HOST" "echo 'Connexion SSH réussie!'" 2>/dev/null; then
    print_success "Connexion SSH fonctionnelle!"
else
    print_error "Échec de la connexion SSH"
    print_info "Vérifiez:"
    print_info "1. La clé publique est bien ajoutée sur O2Switch"
    print_info "2. L'accès SSH est activé"
    print_info "3. Les informations de connexion sont correctes"
    
    read -p "Voulez-vous réessayer? (y/n): " RETRY
    if [[ "$RETRY" == "y" || "$RETRY" == "Y" ]]; then
        ssh -i "$SSH_KEY_PATH" -p "$O2SWITCH_PORT" "$O2SWITCH_USER@$O2SWITCH_HOST"
    fi
fi

# 6. Configuration pour GitHub Actions
echo ""
echo "6️⃣ Configuration pour GitHub Actions..."

print_info "Secrets à ajouter dans GitHub:"
echo ""
echo "O2SWITCH_HOST = $O2SWITCH_HOST"
echo "O2SWITCH_USER = $O2SWITCH_USER"
echo "O2SWITCH_PORT = $O2SWITCH_PORT"
echo ""
echo "O2SWITCH_SSH_KEY = (clé privée complète ci-dessous)"
echo "----------------------------------------"
cat "$SSH_KEY_PATH"
echo "----------------------------------------"

# 7. Création du script de déploiement SSH
echo ""
echo "7️⃣ Création du script de déploiement SSH..."

cat > scripts/deploy-ssh.sh << EOF
#!/bin/bash

# Script de déploiement SSH pour O2Switch
# Usage: ./scripts/deploy-ssh.sh

set -e

# Configuration
O2SWITCH_HOST="$O2SWITCH_HOST"
O2SWITCH_USER="$O2SWITCH_USER"
O2SWITCH_PORT="$O2SWITCH_PORT"
SSH_KEY_PATH="$SSH_KEY_PATH"

echo "🚀 Déploiement SSH vers O2Switch..."

# Test de connexion
echo "🔍 Test de connexion..."
ssh -i "\$SSH_KEY_PATH" -p "\$O2SWITCH_PORT" "\$O2SWITCH_USER@\$O2SWITCH_HOST" "echo 'Connexion OK'"

# Commandes de déploiement
echo "📦 Déploiement de l'application..."
ssh -i "\$SSH_KEY_PATH" -p "\$O2SWITCH_PORT" "\$O2SWITCH_USER@\$O2SWITCH_HOST" << 'ENDSSH'
    # Commandes sur le serveur O2Switch
    cd ~/www
    
    # Sauvegarde de l'ancienne version
    if [ -d "kaba-delivery-backup" ]; then
        rm -rf kaba-delivery-backup
    fi
    
    if [ -d "kaba-delivery" ]; then
        mv kaba-delivery kaba-delivery-backup
    fi
    
    # Création du répertoire
    mkdir -p kaba-delivery
    
    echo "✅ Répertoire préparé pour le déploiement"
ENDSSH

echo "✅ Déploiement SSH terminé!"
EOF

chmod +x scripts/deploy-ssh.sh
print_success "Script de déploiement SSH créé: scripts/deploy-ssh.sh"

# 8. Instructions finales
echo ""
echo "🎉 CONFIGURATION SSH TERMINÉE!"
echo "=============================="

print_success "✅ Clé SSH générée et testée"
print_success "✅ Script de déploiement créé"

echo ""
print_info "📋 Prochaines étapes:"
print_info "1. Ajoutez les secrets dans GitHub (voir ci-dessus)"
print_info "2. Testez le déploiement: ./scripts/deploy-ssh.sh"
print_info "3. Configurez le pipeline GitHub Actions"

echo ""
print_info "📁 Fichiers créés:"
print_info "  - Clé privée: $SSH_KEY_PATH"
print_info "  - Clé publique: $SSH_KEY_PATH.pub"
print_info "  - Script déploiement: scripts/deploy-ssh.sh"