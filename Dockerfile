# Multi-stage build pour optimiser la taille de l'image
FROM node:18-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances
RUN npm ci --only=production && npm cache clean --force

# Copier le code source
COPY . .

# Construire l'application
RUN npm run build

# Stage de production
FROM node:18-alpine AS production

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs && \
    adduser -S kaba -u 1001 -G nodejs

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires depuis le stage builder
COPY --from=builder --chown=kaba:nodejs /app/dist ./dist
COPY --from=builder --chown=kaba:nodejs /app/package*.json ./
COPY --from=builder --chown=kaba:nodejs /app/node_modules ./node_modules

# Changer vers l'utilisateur non-root
USER kaba

# Exposer le port
EXPOSE 3000

# Définir les variables d'environnement
ENV NODE_ENV=production
ENV PORT=3000

# Commande de démarrage
CMD ["npm", "start"]

# Labels pour la traçabilité
LABEL maintainer="AFRIQ-LOGISTIX DevOps Team"
LABEL version="1.0.0"
LABEL description="KABA-DELIVERY Application Container"