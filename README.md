# KABA-DELIVERY

Application de livraison du dernier kilomètre développée par AFRIQ-LOGISTIX S.A.

## Description
KABA-DELIVERY est une solution complète composée d'une API REST et d'un portail de suivi en temps réel pour la gestion des livraisons urbaines à Douala, Cameroun.

## Technologies
- Frontend: React 18 + Vite
- Backend: Node.js
- Base de données: JSON Server (développement)
- Conteneurisation: Docker
- CI/CD: GitHub Actions
- Monitoring: ELK Stack + Grafana

## Installation

### Prérequis
- Node.js 18+
- Docker
- Git

### Développement local
```bash
# Cloner le projet
git clone <repository-url>
cd kaba-delivery

# Installer les dépendances
npm install

# Lancer en mode développement
npm run dev
```

### Production avec Docker
```bash
# Construire l'image
docker build -t kaba-delivery .

# Lancer le conteneur
docker run -p 3000:3000 kaba-delivery
```

## Structure du projet
```
kaba-delivery/
├── src/                    # Code source React
├── public/                 # Fichiers statiques
├── tests/                  # Tests unitaires
├── docker/                 # Configuration Docker
├── .github/workflows/      # Pipeline CI/CD
├── monitoring/             # Configuration ELK + Grafana
└── docs/                   # Documentation
```

## Contribution
Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les guidelines de contribution.

## Licence
Propriété d'AFRIQ-LOGISTIX S.A.