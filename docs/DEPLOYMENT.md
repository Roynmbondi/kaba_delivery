# Guide de Déploiement - KABA-DELIVERY

## Vue d'ensemble

Ce guide vous accompagne dans le déploiement complet de l'application KABA-DELIVERY, de l'environnement de développement jusqu'à la production sur O2Switch.

## Prérequis

### Outils requis
- **Node.js 18+** et npm
- **Docker** et Docker Compose
- **Git**
- Compte **GitHub/GitLab**
- Compte **Docker Hub**
- Hébergement **O2Switch** avec accès SSH

### Comptes et services
- [ ] Compte GitHub/GitLab configuré
- [ ] Compte Docker Hub créé
- [ ] Accès SSH O2Switch configuré
- [ ] Instance SonarQube (locale ou cloud)

## Étape 1: Configuration Locale

### 1.1 Cloner et installer
```bash
git clone <votre-repository>
cd kaba-delivery
npm install
```

### 1.2 Démarrage développement
```bash
# Méthode 1: Script automatique
chmod +x scripts/start-dev.sh
./scripts/start-dev.sh

# Méthode 2: Manuel
npm run dev
```

### 1.3 Tests locaux
```bash
# Tests complets
chmod +x scripts/test-all.sh
./scripts/test-all.sh

# Tests individuels
npm run lint
npm run test
npm run test:coverage
npm run build
```

## Étape 2: Configuration Git et Branches

### 2.1 Initialisation du repository
```bash
# Créer le repository sur GitHub/GitLab
# Puis localement:
git init
git add .
git commit -m "feat: initial commit KABA-DELIVERY"
git branch -M main
git remote add origin <URL_REPOSITORY>
git push -u origin main
```

### 2.2 Création des branches
```bash
# Branche de développement
git checkout -b develop
git push -u origin develop

# Branche de fonctionnalité
git checkout -b feature/api-delivery
git push -u origin feature/api-delivery
```

### 2.3 Protection des branches (Interface GitHub/GitLab)
1. Aller dans **Settings > Branches**
2. Ajouter une règle pour `main`:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Restrict pushes that create files larger than 100MB
   - ❌ Allow force pushes

## Étape 3: Configuration des Secrets

### 3.1 Secrets GitHub (Settings > Secrets and variables > Actions)
```
DOCKER_USERNAME          # Votre nom d'utilisateur Docker Hub
DOCKER_PASSWORD          # Token Docker Hub (pas le mot de passe!)
SONAR_TOKEN             # Token SonarQube
O2SWITCH_HOST           # IP/domaine de votre serveur O2Switch
O2SWITCH_USER           # Nom d'utilisateur SSH
O2SWITCH_SSH_KEY        # Clé privée SSH (format PEM complet)
O2SWITCH_PORT           # Port SSH (22 par défaut)
PRODUCTION_URL          # URL de production finale
```

### 3.2 Génération des tokens

#### Docker Hub Token
1. Aller sur [Docker Hub](https://hub.docker.com)
2. **Account Settings > Security > New Access Token**
3. Nom: `kaba-delivery-ci`
4. Permissions: `Read, Write, Delete`

#### SonarQube Token
1. Interface SonarQube > **My Account > Security**
2. **Generate Token**: `kaba-delivery-token`
3. Copier le token généré

#### Clé SSH O2Switch
```bash
# Générer une nouvelle clé SSH
ssh-keygen -t rsa -b 4096 -C "kaba-delivery@afriq-logistix.com"

# Copier la clé publique sur O2Switch
ssh-copy-id -i ~/.ssh/id_rsa.pub user@your-o2switch-server.com

# Copier la clé privée complète dans le secret GitHub
cat ~/.ssh/id_rsa
```

## Étape 4: Configuration SonarQube

### 4.1 SonarQube local (Docker)
```bash
# Démarrer SonarQube
docker run -d --name sonarqube -p 9000:9000 sonarqube:latest

# Accéder à http://localhost:9000
# Login: admin / admin (changer le mot de passe)
```

### 4.2 Configuration du projet
1. **Create Project** > `kaba-delivery`
2. **Generate Token** pour CI/CD
3. Copier le token dans les secrets GitHub

## Étape 5: Premier Déploiement

### 5.1 Push vers main
```bash
git checkout main
git merge develop
git push origin main
```

### 5.2 Surveillance du pipeline
1. Aller dans **Actions** (GitHub) ou **CI/CD** (GitLab)
2. Surveiller l'exécution du pipeline
3. Vérifier chaque étape:
   - ✅ Lint & Test
   - ✅ Code Quality (SonarQube)
   - ✅ Security Scan
   - ✅ Build & Push Docker
   - ✅ Deploy to O2Switch

### 5.3 Vérification du déploiement
```bash
# Test de l'application déployée
curl -f https://your-production-url.com

# Vérification des logs
ssh user@your-o2switch-server.com
docker logs kaba-delivery
```

## Étape 6: Configuration du Monitoring

### 6.1 Démarrage de la stack de monitoring
```bash
# Sur votre serveur de monitoring (local ou distant)
chmod +x scripts/monitoring-setup.sh
./scripts/monitoring-setup.sh
```

### 6.2 Accès aux dashboards
- **Kibana (Logs)**: http://localhost:5601
- **Grafana (Métriques)**: http://localhost:3001 (admin/admin123)
- **Prometheus**: http://localhost:9090
- **Elasticsearch**: http://localhost:9200

### 6.3 Configuration des alertes
1. Accéder à Grafana
2. **Alerting > Alert Rules**
3. Importer les règles depuis `monitoring/prometheus/rules/`

## Étape 7: Tests Post-Déploiement

### 7.1 Tests fonctionnels
```bash
# Test de santé de base
curl -f https://your-production-url.com

# Test des endpoints critiques
curl -f https://your-production-url.com/api/health
```

### 7.2 Tests de performance
```bash
# Test de charge basique avec curl
for i in {1..10}; do
  time curl -s https://your-production-url.com > /dev/null
done
```

### 7.3 Vérification des logs
```bash
# Logs de l'application
ssh user@server "docker logs kaba-delivery --tail 50"

# Logs du système
ssh user@server "tail -f /var/log/syslog"
```

## Dépannage

### Problèmes courants

#### Pipeline CI/CD échoue
```bash
# Vérifier les secrets
# Vérifier les permissions Docker Hub
# Vérifier la connectivité SSH O2Switch
```

#### Application ne démarre pas
```bash
# Vérifier les logs Docker
docker logs kaba-delivery

# Vérifier les variables d'environnement
docker exec kaba-delivery env
```

#### Monitoring non accessible
```bash
# Vérifier les services Docker
docker-compose -f monitoring/docker-compose.monitoring.yml ps

# Redémarrer les services
docker-compose -f monitoring/docker-compose.monitoring.yml restart
```

### Logs utiles
```bash
# Logs du pipeline GitHub Actions
# Interface GitHub > Actions > Workflow run

# Logs Docker sur O2Switch
ssh user@server "docker logs kaba-delivery"

# Logs système
ssh user@server "journalctl -u docker"
```

## Maintenance

### Mises à jour
```bash
# Mise à jour des dépendances
npm update
npm audit fix

# Mise à jour des images Docker
docker pull node:18-alpine
docker system prune -f
```

### Sauvegarde
```bash
# Sauvegarde des données
ssh user@server "docker exec kaba-delivery tar -czf /backup/app-data.tar.gz /app/data"

# Sauvegarde de la configuration
git push origin main  # Le code est déjà sauvegardé
```

### Monitoring continu
- Surveiller les dashboards Grafana quotidiennement
- Vérifier les alertes Prometheus
- Analyser les logs Kibana hebdomadairement
- Effectuer des tests de performance mensuellement

## Support

### Contacts
- **Équipe DevOps**: devops@afriq-logistix.com
- **Support technique**: support@afriq-logistix.com
- **Documentation**: https://docs.afriq-logistix.com

### Ressources
- [Documentation Docker](https://docs.docker.com/)
- [Guide GitHub Actions](https://docs.github.com/en/actions)
- [Documentation O2Switch](https://www.o2switch.fr/documentation/)
- [Guide SonarQube](https://docs.sonarqube.org/)

---

**🎉 Félicitations ! KABA-DELIVERY est maintenant déployé et opérationnel !**