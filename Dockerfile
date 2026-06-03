FROM python:3.9-slim
WORKDIR /app
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 1. On copie d'abord le fichier des dépendances qui est à la racine
COPY requirements.txt .

# 2. On copie tout le contenu du dossier voting-app (main.py, static, etc.)
COPY ./voting-app .

# 3. Maintenant pip va trouver le fichier !
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80
ENV REDIS=redis-db
ENV REDIS_PWD=mon_pass
CMD ["python", "main.py"]
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
