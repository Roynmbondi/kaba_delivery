# Configuration des Secrets GitHub - KABA-DELIVERY

## 🔐 Guide de Configuration des Secrets

Ce guide vous explique comment configurer tous les secrets nécessaires pour le pipeline CI/CD de KABA-DELIVERY.

## 1. 🐳 Secrets Docker Hub

### Étape 1: Créer un Token Docker Hub

1. **Connectez-vous à Docker Hub**: https://hub.docker.com/
2. **Allez dans Account Settings** → **Security**
3. **Cliquez sur "New Access Token"**
4. **Configurez le token**:
   - **Description**: `KABA-DELIVERY-CI-CD`
   - **Permissions**: `Read, Write, Delete`
5. **Copiez le token généré** (vous ne pourrez plus le voir après)

### Étape 2: Configurer les Secrets GitHub

1. **Allez sur votre repository GitHub**: https://github.com/Roynmbondi/kaba_delivery
2. **Settings** → **Secrets and variables** → **Actions**
3. **Ajoutez ces secrets**:

#### DOCKER_USERNAME
- **Name**: `DOCKER_USERNAME`
- **Secret**: Votre nom d'utilisateur Docker Hub (ex: `roynmbondi`)

#### DOCKER_PASSWORD
- **Name**: `DOCKER_PASSWORD`
- **Secret**: Le token Docker Hub que vous avez copié

## 2. 🔍 Secrets SonarQube (Optionnel)

### SONAR_TOKEN
- **Name**: `SONAR_TOKEN`
- **Secret**: Token de votre instance SonarQube
- **Comment l'obtenir**:
  1. Connectez-vous à SonarQube
  2. User → My Account → Security
  3. Generate Token

## 3. 🚀 Secrets O2Switch (Pour le déploiement)

### SSH (Recommandé)
#### O2SWITCH_HOST
- **Name**: `O2SWITCH_HOST`
- **Secret**: `ssh.o2switch.net` ou votre domaine

#### O2SWITCH_USERNAME
- **Name**: `O2SWITCH_USERNAME`
- **Secret**: Votre nom d'utilisateur O2Switch

#### O2SWITCH_SSH_KEY
- **Name**: `O2SWITCH_SSH_KEY`
- **Secret**: Votre clé privée SSH (contenu du fichier `~/.ssh/id_rsa`)

#### O2SWITCH_PATH
- **Name**: `O2SWITCH_PATH`
- **Secret**: Chemin vers votre dossier web (ex: `/home/username/www`)

### FTP (Alternative)
#### O2SWITCH_FTP_HOST
- **Name**: `O2SWITCH_FTP_HOST`
- **Secret**: Serveur FTP O2Switch

#### O2SWITCH_FTP_USERNAME
- **Name**: `O2SWITCH_FTP_USERNAME`
- **Secret**: Nom d'utilisateur FTP

#### O2SWITCH_FTP_PASSWORD
- **Name**: `O2SWITCH_FTP_PASSWORD`
- **Secret**: Mot de passe FTP

## 4. 📊 Secrets Monitoring (Optionnel)

### GRAFANA_API_KEY
- **Name**: `GRAFANA_API_KEY`
- **Secret**: Clé API Grafana pour la configuration automatique

### ELASTICSEARCH_PASSWORD
- **Name**: `ELASTICSEARCH_PASSWORD`
- **Secret**: Mot de passe Elasticsearch

## 5. ✅ Vérification des Secrets

Une fois tous les secrets configurés, votre liste devrait ressembler à:

```
✅ DOCKER_USERNAME
✅ DOCKER_PASSWORD
⚠️ SONAR_TOKEN (optionnel)
✅ O2SWITCH_HOST
✅ O2SWITCH_USERNAME
✅ O2SWITCH_SSH_KEY
✅ O2SWITCH_PATH
```

## 6. 🧪 Test des Secrets

### Test Docker Hub
```bash
# Test local de connexion Docker Hub
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
```

### Test SSH O2Switch
```bash
# Test de connexion SSH
ssh -i ~/.ssh/id_rsa $O2SWITCH_USERNAME@$O2SWITCH_HOST "pwd"
```

## 7. 🚨 Sécurité

### ⚠️ Bonnes Pratiques
- ✅ **Jamais de secrets dans le code**
- ✅ **Utilisez des tokens avec permissions limitées**
- ✅ **Renouvelez les tokens régulièrement**
- ✅ **Supprimez les tokens inutilisés**

### 🔒 Secrets à NE JAMAIS commiter
- Mots de passe
- Tokens d'API
- Clés SSH privées
- Chaînes de connexion de base de données

## 8. 🔧 Dépannage

### Erreur "Invalid credentials"
1. Vérifiez que le token Docker Hub est correct
2. Vérifiez que le nom d'utilisateur est exact
3. Régénérez le token si nécessaire

### Erreur "Permission denied"
1. Vérifiez les permissions du token
2. Assurez-vous que le repository Docker Hub existe
3. Vérifiez que vous êtes propriétaire du repository

### Pipeline qui échoue
1. Vérifiez que tous les secrets requis sont configurés
2. Regardez les logs détaillés dans GitHub Actions
3. Testez les connexions localement

## 9. 📞 Support

Si vous rencontrez des problèmes:
1. Vérifiez les logs GitHub Actions
2. Testez les connexions localement
3. Consultez la documentation officielle:
   - [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
   - [Docker Hub Tokens](https://docs.docker.com/docker-hub/access-tokens/)
   - [O2Switch SSH](https://faq.o2switch.fr/hebergement-mutualise/acces-ssh)