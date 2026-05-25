# Guide de Contribution - KABA-DELIVERY

## Convention de Nommage des Commits (Conventional Commits)

Nous utilisons la convention Conventional Commits pour maintenir un historique de commits clair et automatiser le versioning.

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types de commits
- **feat**: Nouvelle fonctionnalité
- **fix**: Correction de bug
- **docs**: Documentation uniquement
- **style**: Changements qui n'affectent pas le sens du code (espaces, formatage, etc.)
- **refactor**: Changement de code qui ne corrige pas de bug ni n'ajoute de fonctionnalité
- **perf**: Changement de code qui améliore les performances
- **test**: Ajout de tests manquants ou correction de tests existants
- **chore**: Changements aux outils de build ou aux dépendances

### Exemples
```
feat(api): add delivery tracking endpoint
fix(auth): resolve token expiration issue
docs: update API documentation
test(delivery): add unit tests for delivery service
chore(deps): update dependencies to latest versions
```

## Stratégie de Branches (GitHub Flow)

### Branches principales
- **main**: Branche de production, toujours déployable
- **develop**: Branche d'intégration pour les nouvelles fonctionnalités

### Branches de fonctionnalités
- **feature/**: Nouvelles fonctionnalités (`feature/api-delivery`, `feature/user-auth`)
- **hotfix/**: Corrections urgentes en production (`hotfix/critical-bug`)
- **release/**: Préparation des releases (`release/v1.2.0`)

### Workflow
1. Créer une branche feature à partir de `develop`
2. Développer la fonctionnalité
3. Créer une Pull Request vers `develop`
4. Code review obligatoire
5. Tests automatiques passés
6. Merge après validation

### Règles de Protection
- Pas de push direct sur `main` et `develop`
- Pull Request obligatoire avec au moins 1 reviewer
- Tests CI/CD passés obligatoirement
- Pas de force push autorisé

## Processus de Review
1. Le code doit respecter les standards de qualité (SonarQube)
2. Les tests unitaires doivent passer (couverture > 80%)
3. La documentation doit être mise à jour si nécessaire
4. Le reviewer doit approuver explicitement

## Contact
Pour toute question, contactez l'équipe DevOps d'AFRIQ-LOGISTIX.