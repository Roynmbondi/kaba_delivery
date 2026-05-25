#!/bin/bash

# Script de démarrage pour l'environnement de développement KABA-DELIVERY
# Usage: ./scripts/start-dev.sh

set -e

echo "🚀 Démarrage de l'environnement de développement KABA-DELIVERY"

# Vérification des prérequis
echo "🔍 Vérification des prérequis..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Veuillez installer Node.js 18+"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm n'est pas installé"
    exit 1
fi

# Vérification de la version Node.js
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ requis. Version actuelle: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v) détecté"
echo "✅ npm $(npm -v) détecté"

# Installation des dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
else
    echo "✅ Dépendances déjà installées"
fi

# Création du fichier .env local s'il n'existe pas
if [ ! -f ".env.local" ]; then
    echo "🔧 Création du fichier .env.local..."
    cat > .env.local << EOF
# Configuration locale pour KABA-DELIVERY
NODE_ENV=development
PORT=3000
VITE_API_BASE_URL=http://localhost:3001
VITE_APP_NAME=KABA-DELIVERY
VITE_APP_VERSION=1.0.0
EOF
    echo "✅ Fichier .env.local créé"
fi

# Démarrage du serveur JSON (simulation API)
echo "🗄️ Démarrage du serveur JSON (API simulation)..."
if [ -f "Royn_Mbondi_CookBook_React/cookbook/db.json" ]; then
    npx json-server --watch Royn_Mbondi_CookBook_React/cookbook/db.json --port 3001 &
    JSON_SERVER_PID=$!
    echo "✅ Serveur JSON démarré sur le port 3001 (PID: $JSON_SERVER_PID)"
else
    echo "⚠️ Fichier db.json non trouvé, création d'un fichier par défaut..."
    mkdir -p data
    echo '{"recettes": []}' > data/db.json
    npx json-server --watch data/db.json --port 3001 &
    JSON_SERVER_PID=$!
fi

# Attendre que le serveur JSON soit prêt
echo "⏳ Attente du démarrage du serveur JSON..."
sleep 3

# Vérification que le serveur JSON fonctionne
if curl -f http://localhost:3001 > /dev/null 2>&1; then
    echo "✅ Serveur JSON accessible"
else
    echo "❌ Serveur JSON non accessible"
fi

# Démarrage du serveur de développement Vite
echo "🚀 Démarrage du serveur de développement..."
echo ""
echo "📱 Application KABA-DELIVERY sera disponible sur:"
echo "   🌐 Local:   http://localhost:3000"
echo "   🌐 Réseau:  http://$(hostname -I | awk '{print $1}'):3000"
echo ""
echo "📊 API JSON Server disponible sur:"
echo "   🔗 http://localhost:3001"
echo ""
echo "⚡ Hot reload activé - Les modifications seront automatiquement rechargées"
echo ""
echo "🛑 Pour arrêter les serveurs: Ctrl+C"
echo ""

# Fonction de nettoyage à l'arrêt
cleanup() {
    echo ""
    echo "🛑 Arrêt des serveurs..."
    if [ ! -z "$JSON_SERVER_PID" ]; then
        kill $JSON_SERVER_PID 2>/dev/null || true
        echo "✅ Serveur JSON arrêté"
    fi
    echo "👋 Au revoir!"
    exit 0
}

# Capture des signaux d'arrêt
trap cleanup SIGINT SIGTERM

# Démarrage de Vite
npm run dev

# Si on arrive ici, c'est que Vite s'est arrêté
cleanup