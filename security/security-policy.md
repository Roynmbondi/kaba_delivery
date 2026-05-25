# Politique de Sécurité - KABA-DELIVERY

## Gestion des Secrets

### Principes de base
- ❌ **JAMAIS** de secrets hardcodés dans le code source
- ✅ Utilisation exclusive des variables d'environnement et secrets du CI/CD
- ✅ Rotation régulière des clés et tokens
- ✅ Principe du moindre privilège

### Secrets requis pour le pipeline CI/CD

#### GitHub Secrets (Repository Settings > Secrets)
```
DOCKER_USERNAME          # Nom d'utilisateur Docker Hub
DOCKER_PASSWORD          # Token d'accès Docker Hub (pas le mot de passe)
SONAR_TOKEN             # Token SonarQube pour l'analyse de code
O2SWITCH_HOST           # Adresse IP/domaine du serveur O2Switch
O2SWITCH_USER           # Nom d'utilisateur SSH O2Switch
O2SWITCH_SSH_KEY        # Clé privée SSH (format PEM)
O2SWITCH_PORT           # Port SSH (optionnel, défaut: 22)
PRODUCTION_URL          # URL de production pour les tests post-déploiement
```

#### Variables d'environnement de production
```
NODE_ENV=production
PORT=3000
API_BASE_URL=https://api.kaba-delivery.com
DATABASE_URL=postgresql://user:pass@host:port/db
JWT_SECRET=your-super-secure-jwt-secret
MAPS_API_KEY=your-maps-api-key
```

## Analyse de Vulnérabilités

### Outils intégrés
1. **Trivy** - Scan des vulnérabilités des conteneurs
2. **SonarQube** - Analyse statique du code
3. **GitHub Security** - Alertes de dépendances
4. **ESLint** - Détection des problèmes de sécurité JavaScript

### Seuils de blocage
- Vulnérabilités **CRITICAL** ou **HIGH** → Pipeline bloqué
- Couverture de tests < 80% → Pipeline bloqué
- Quality Gate SonarQube échoué → Pipeline bloqué

## Bonnes Pratiques

### Conteneurs
- ✅ Utilisateur non-root dans les conteneurs
- ✅ Images de base officielles et mises à jour
- ✅ Multi-stage builds pour réduire la surface d'attaque
- ✅ Scan régulier des vulnérabilités

### Code
- ✅ Validation des entrées utilisateur
- ✅ Échappement des données de sortie
- ✅ Gestion sécurisée des erreurs
- ✅ Logs sans informations sensibles

### Infrastructure
- ✅ HTTPS obligatoire en production
- ✅ Pare-feu configuré
- ✅ Accès SSH par clé uniquement
- ✅ Monitoring des accès