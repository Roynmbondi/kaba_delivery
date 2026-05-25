# Architecture Technique - KABA-DELIVERY

## Vue d'ensemble

KABA-DELIVERY est une application de livraison du dernier kilomètre développée pour AFRIQ-LOGISTIX S.A., utilisant une architecture moderne basée sur des conteneurs Docker et des pratiques DevOps avancées.

## Architecture Globale

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Développeur   │    │   GitHub/GitLab │    │   Docker Hub    │
│                 │───▶│                 │───▶│                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SonarQube     │◀───│   CI/CD Pipeline│───▶│   O2Switch      │
│   (Qualité)     │    │   (GitHub Actions)   │   (Production)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ELK Stack     │◀───│   Monitoring    │◀───│   Application   │
│   (Logs)        │    │   (Grafana)     │    │   (React)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Composants Techniques

### 1. Application Frontend
- **Framework**: React 18 avec Vite
- **Langage**: JavaScript ES6+
- **Styling**: CSS-in-JS (styles inline)
- **Tests**: Vitest + Testing Library
- **Linting**: ESLint avec configuration React

### 2. Conteneurisation
- **Runtime**: Docker avec multi-stage builds
- **Base Image**: Node.js 18 Alpine
- **Sécurité**: Utilisateur non-root (kaba:1001)
- **Optimisation**: Images légères, cache layers

### 3. Pipeline CI/CD
- **Plateforme**: GitHub Actions
- **Étapes**:
  1. Lint & Test (ESLint + Vitest)
  2. Code Quality (SonarQube)
  3. Security Scan (Trivy)
  4. Build & Push (Docker Hub)
  5. Deploy (O2Switch via SSH)
  6. Post-deployment Tests

### 4. Monitoring et Observabilité
- **Logs**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Métriques**: Prometheus + Grafana
- **Alerting**: Prometheus AlertManager
- **Collecte**: Filebeat, Node Exporter, cAdvisor

## Sécurité

### Mesures Implémentées
1. **Secrets Management**: Variables d'environnement chiffrées
2. **Container Security**: Utilisateur non-root, images scannées
3. **Code Quality**: SonarQube avec Quality Gates
4. **Vulnerability Scanning**: Trivy pour conteneurs et dépendances
5. **Access Control**: SSH par clés, pas de mots de passe hardcodés

### Quality Gates
- Couverture de tests > 80%
- Pas de vulnérabilités CRITICAL/HIGH
- Respect des standards de code
- Pas de secrets dans le code

## Infrastructure

### Environnement de Production (O2Switch)
- **Hébergement**: Cloud O2Switch
- **Accès**: SSH avec clés privées
- **Déploiement**: Automatisé via GitHub Actions
- **Monitoring**: Dashboards Grafana accessibles

### Environnement de Développement Local
- **Stack**: Docker Compose
- **Services**: Application + JSON Server (mock API)
- **Monitoring**: Stack ELK + Prometheus/Grafana
- **Développement**: Hot reload avec Vite

## Flux de Données

### 1. Développement → Production
```
Code Push → GitHub → CI/CD → Tests → Build → Docker Hub → Deploy → O2Switch
```

### 2. Monitoring
```
Application → Logs → Filebeat → Logstash → Elasticsearch → Kibana
Application → Métriques → Prometheus → Grafana → Alertes
```

## Métriques Surveillées

### Application
- Statut de l'application (UP/DOWN)
- Taux de requêtes par minute
- Temps de réponse (percentiles)
- Taux d'erreur HTTP

### Système
- Utilisation CPU
- Utilisation mémoire
- Espace disque disponible
- Charge système

### Alertes Configurées
- Application indisponible > 1 min
- CPU > 80% pendant 5 min
- Mémoire > 85% pendant 5 min
- Espace disque < 10%
- Taux d'erreur > 5%

## Justification des Choix Architecturaux

### 1. React + Vite
- **Performance**: Build rapide, hot reload
- **Écosystème**: Large communauté, nombreuses ressources
- **Maintenabilité**: Code modulaire, composants réutilisables

### 2. Docker Multi-stage
- **Sécurité**: Images légères, surface d'attaque réduite
- **Performance**: Optimisation des layers, cache efficace
- **Portabilité**: Même environnement dev/prod

### 3. GitHub Actions
- **Intégration**: Native avec GitHub
- **Flexibilité**: Workflows personnalisables
- **Coût**: Gratuit pour projets privés (limites généreuses)

### 4. ELK Stack
- **Scalabilité**: Gestion de gros volumes de logs
- **Recherche**: Capacités de recherche avancées
- **Visualisation**: Dashboards riches avec Kibana

### 5. Prometheus + Grafana
- **Standard**: De facto pour le monitoring cloud-native
- **Alerting**: Système d'alertes robuste
- **Visualisation**: Dashboards professionnels

## Évolutions Futures

### Court terme
- Ajout d'une API REST (Node.js/Express)
- Base de données PostgreSQL
- Authentification JWT
- Tests end-to-end (Playwright)

### Moyen terme
- Microservices architecture
- Kubernetes pour l'orchestration
- Service mesh (Istio)
- Monitoring distribué (Jaeger)

### Long terme
- Architecture event-driven
- CQRS/Event Sourcing
- Multi-cloud deployment
- Machine Learning pour l'optimisation des livraisons