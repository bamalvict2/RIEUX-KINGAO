FROM mongo:7.0

# Répertoire des données
VOLUME /data/db

# Port interne MongoDB
EXPOSE 27017

# Commande par défaut
CMD ["mongod", "--bind_ip_all"]
