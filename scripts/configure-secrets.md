# 🔐 Configuration des Secrets GitHub - KABA-DELIVERY

## Vue d'ensemble
Ce guide vous aide à configurer tous les secrets nécessaires pour le pipeline CI/CD.

## 📋 Liste des Secrets Requis

### Secrets GitHub Actions
Aller dans votre repository GitHub > **Settings** > **Secrets and variables** > **Actions** > **New repository secret**

| Nom du Secret | Description | Comment l'obtenir |
|---------------|-------------|-------------------|
| `DOCKER_USERNAME` | Nom d'utilisateur Docker Hub | Votre username Docker Hub |
| `DOCKER_PASSWORD` | Token d'accès Docker Hub | Générer un token (pas le mot de passe!) |
| `SONAR_TOKEN` | Token SonarQube | Générer depuis votre instance SonarQube |
| `O2SWITCH_HOST` | Adresse serveur O2Switch | IP ou domaine de votre serveur |
| `O2SWITCH_USER` | Utilisateur SSH O2Switch | Nom d'utilisateur SSH |
| `O2SWITCH_SSH_KEY` | Clé privée SSH | Clé privée complète (format PEM) |
| `O2SWITCH_PORT` | Port SSH (optionnel) | Port SSH (défaut: 22) |
| `PRODUCTION_URL` | URL de production | URL finale de l'application |

## 🐳 1. Configuration Docker Hub

### Créer un compte Docker Hub
1. Aller sur https://hub.docker.com
2. Créer un compte ou se connecter
3. Noter votre **username** (sera `DOCKER_USERNAME`)

### Générer un Access Token
1. Aller dans **Account Settings** > **Security**
2. Cliquer **New Access Token**
3. Nom: `kaba-delivery-ci`
4. Permissions: **Read, Write, Delete**
5. Copier le token généré (sera `DOCKER_PASSWORD`)

⚠️ **Important**: Utilisez le TOKEN, pas votre mot de passe!

## 🔍 2. Configuration SonarQube

### Option A: SonarQube Local (Docker)
```bash
# Démarrer SonarQube
docker run -d --name sonarqube -p 9000:9000 sonarqube:latest

# Attendre le démarrage (2-3 minutes)
# Accéder à http://localhost:9000
# Login: admin / admin (changer le mot de passe)
```

### Option B: SonarCloud (Gratuit)
1. Aller sur https://sonarcloud.io
2. Se connecter avec GitHub
3. Créer une organisation
4. Importer le projet `kaba-delivery`

### Générer le Token
1. **My Account** > **Security** > **Generate Tokens**
2. Nom: `kaba-delivery-token`
3. Type: **User Token**
4. Copier le token (sera `SONAR_TOKEN`)

## 🌐 3. Configuration O2Switch

### Informations Serveur
- `O2SWITCH_HOST`: Adresse IP ou domaine de votre serveur
- `O2SWITCH_USER`: Nom d'utilisateur SSH
- `O2SWITCH_PORT`: Port SSH (généralement 22)

### Génération Clé SSH
```bash
# Générer une nouvelle paire de clés
ssh-keygen -t rsa -b 4096 -C "kaba-delivery@afriq-logistix.com" -f ~/.ssh/kaba_delivery

# Copier la clé publique sur le serveur
ssh-copy-id -i ~/.ssh/kaba_delivery.pub user@your-server.com

# Tester la connexion
ssh -i ~/.ssh/kaba_delivery user@your-server.com

# Copier la clé privée COMPLÈTE pour GitHub
cat ~/.ssh/kaba_delivery
```

⚠️ **Important**: Copiez la clé privée COMPLÈTE (de `-----BEGIN` à `-----END`)

### URL de Production
- Format: `https://votre-domaine.com` ou `http://ip-serveur:3000`
- Sera utilisée pour les tests post-déploiement

## 🔧 4. Configuration dans GitHub

### Accéder aux Secrets
1. Aller dans votre repository GitHub
2. **Settings** > **Secrets and variables** > **Actions**
3. Cliquer **New repository secret**

### Ajouter chaque secret
Pour chaque secret de la liste:
1. **Name**: Nom exact du secret (ex: `DOCKER_USERNAME`)
2. **Secret**: Valeur du secret
3. **Add secret**

### Exemple de Configuration

```
DOCKER_USERNAME = votre_username_dockerhub
DOCKER_PASSWORD = dckr_pat_1234567890abcdef...
SONAR_TOKEN = squ_1234567890abcdef...
O2SWITCH_HOST = 192.168.1.100
O2SWITCH_USER = ubuntu
O2SWITCH_SSH_KEY = -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...
(clé complète)
...
-----END RSA PRIVATE KEY-----
O2SWITCH_PORT = 22
PRODUCTION_URL = https://kaba-delivery.votre-domaine.com
```

## ✅ 5. Vérification

### Vérifier les Secrets
1. Dans GitHub: **Settings** > **Secrets and variables** > **Actions**
2. Vous devriez voir tous les secrets listés
3. Les valeurs sont masquées (normal)

### Tester le Pipeline
1. Faire un push vers la branche `main`
2. Aller dans **Actions** pour voir le pipeline
3. Vérifier que toutes les étapes passent

## 🚨 Dépannage

### Erreurs Communes

#### Docker Hub Authentication Failed
- Vérifier que `DOCKER_USERNAME` est correct
- Vérifier que `DOCKER_PASSWORD` est un TOKEN, pas le mot de passe
- Régénérer le token si nécessaire

#### SSH Connection Failed
- Vérifier `O2SWITCH_HOST`, `O2SWITCH_USER`, `O2SWITCH_PORT`
- Vérifier que la clé SSH est complète (avec BEGIN/END)
- Tester la connexion SSH manuellement

#### SonarQube Failed
- Vérifier que `SONAR_TOKEN` est valide
- Vérifier que le projet existe dans SonarQube
- Vérifier la configuration dans `sonar-project.properties`

## 📞 Support

Si vous rencontrez des problèmes:
1. Vérifier les logs dans GitHub Actions
2. Tester chaque service individuellement
3. Consulter la documentation officielle de chaque service

---

**🎯 Une fois tous les secrets configurés, le pipeline CI/CD fonctionnera automatiquement!**