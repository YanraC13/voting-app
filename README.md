# Voting App : conteneurisation et CI/CD avec scan de sécurité

TP du module DevOps (Bachelor 3 Cybersécurité, Ynov Montpellier, 2026).
L'application (Flask + Redis, issue de l'« Azure Voting App ») a été **fournie par le cours**. **Mon travail** porte sur sa conteneurisation, son orchestration et le pipeline d'intégration continue.

![CI](https://github.com/YanraC13/voting-app/actions/workflows/ci.yml/badge.svg)

---

## Architecture

```
Navigateur ──► voting-app (Flask, :8080 → :80) ──► redis-db (Redis, protégé par mot de passe)
```

## Ce que j'ai fait

**1. Dockerfile**
- Image légère `python:3.9-slim`.
- Les dépendances sont copiées et installées **avant** le code, ce qui optimise le cache des couches Docker.
- `HEALTHCHECK` : Docker vérifie toutes les 30 s que l'application répond.

**2. docker-compose**
- Deux services, `voting-app` et `redis-db`.
- Redis démarre avec `--requirepass`, donc la base n'est pas accessible sans mot de passe.

**3. Pipeline CI (GitHub Actions)**, déclenché à chaque push sur `main` :

```
checkout → login Docker Hub → build → scan de CVE (Docker Scout) → push
```

- Les identifiants Docker Hub sont stockés dans les **secrets GitHub**, jamais dans le code.
- L'image est **scannée (Docker Scout) avant d'être publiée** : c'est une démarche DevSecOps.

## Lancer le projet

```bash
docker compose up --build
```

Puis ouvrir http://localhost:8080

## Limites et améliorations

En relisant le projet avec un œil sécurité, je corrigerais :

- **Mot de passe Redis en clair** dans le Dockerfile et le docker-compose (`mon_pass`) → le passer par un fichier `.env` non versionné ou par les *Docker secrets*.
- **Python 3.9 en fin de vie** → passer à une version maintenue.
- **Le scan n'est pas bloquant** → faire échouer le pipeline si une CVE critique est détectée.
- **Conteneur lancé en root** → ajouter un utilisateur non privilégié (`USER`).
