# --- Étape 1: La Construction (Build Stage) ---
# Utiliser une image Node.js récente pour compiler le code
FROM node:20-alpine AS builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de dépendances (package.json et package-lock.json)
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier le reste du code source
COPY . .

# Lancer la construction de l'application (Vite génère le dossier 'dist')
RUN npm run build
 

# --- Étape 2: Le Serveur (Production Stage) ---
# Utiliser une image Nginx très légère pour servir les fichiers statiques
FROM nginx:alpine

# Copier les fichiers de build optimisés de l'étape 'builder' vers le répertoire de Nginx
# Les applications React/Vite construites sont statiques, Nginx est le meilleur moyen de les servir.
COPY --from=builder /app/dist /usr/share/nginx/html

# Optionnel: Copier un fichier de configuration Nginx personnalisé (pour React router, si besoin)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port par défaut de Nginx
EXPOSE 80

# Commande par défaut pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]