---
id: S-003
title: Implémenter /work basique
type: feature
status: done
sprint: sprint-00
created: 2025-01-15
---

# S-003: Implémenter /work basique

## Contexte

Après avoir créé une story avec `/story`, l'utilisateur doit pouvoir démarrer le travail dessus. La commande `/work` initialise l'environnement de travail, explore le codebase, propose des options d'architecture, puis Claude implémente en TDD.

## Objectif

En tant que développeur,
je veux lancer `/work S-XXX` pour démarrer le travail sur une story
afin d'avoir ma session configurée, le contexte exploré, et une architecture validée avant d'implémenter.

## Description

La commande `/work` doit :

1. **Valider** : Vérifier que la story est `ready` (guard si non → "utilise `/story` d'abord")
2. **Configurer la session** :
   - Créer/mettre à jour `.claude/session.json`
   - Passer la story en status `active`
3. **Créer la branche** : `feature/#XXX-slug` depuis main
4. **Explorer** : `explore-agent` analyse le codebase existant
5. **Architecturer** : `architect-agent` propose 2-3 options, user choisit
6. **Implémenter** : Claude code en TDD
7. **Review** : `review-agent` vérifie la qualité

### Mono-app vs Multi-app

| Contexte | Comportement |
|----------|--------------|
| Mono-app (comme ce repo) | Pas besoin de `--app`, détection automatique |
| Multi-app | `--app` requis, crée ticket dans le repo de l'app |

## Critères d'acceptation

- [x] `/work S-XXX` démarre une session de travail
- [x] Guard bloque si story pas `ready` avec message clair
- [x] Crée la branche `feature/#XXX-slug` depuis main
- [x] Met à jour la story en status `active`
- [x] Crée/met à jour `.claude/session.json` avec :
  - `active_story`: S-XXX
  - `active_app`: nom de l'app (auto-détecté ou via --app)
  - `active_ticket`: repo#XX (si multi-app)
  - `branch`: feature/#XXX-slug
  - `started_at`: timestamp
  - `status`: working
  - `current_sprint`: sprint-XX
- [x] Crée ticket GitHub dans le repo approprié (multi-app seulement)
- [x] Met à jour la table Tickets dans la story (multi-app seulement)
- [x] `explore-agent` analyse le codebase et retourne fichiers/patterns
- [x] `architect-agent` propose 2-3 options d'architecture
- [x] User valide l'architecture avant implémentation
- [x] Claude implémente en TDD (RED → GREEN → REFACTOR)
- [x] `review-agent` vérifie la qualité avant finalisation
- [x] Option `--app` pour projets multi-app

## Hors scope

- Gestion des conflits si déjà en `/work` sur autre story (future story)
- `/work abort` pour annuler (future story)

## Questions résolues

- Q: Format de branche ?
  R: `feature/#XXX-slug` (où XXX = ID story pour plugins, numéro ticket pour multi-app)

- Q: Mono-app, comment détecter ?
  R: Si une seule app dans `apps/`, pas besoin de `--app`

- Q: Story pas ready ?
  R: Guard qui bloque avec message "utilise `/story` d'abord"

- Q: Qui code ?
  R: Claude code, les agents (explore, architect, review) l'assistent

## Notes techniques

Fichiers créés :
- `apps/flowc/commands/work.md` - Définition de la commande
- `apps/flowc/skills/work.md` - Orchestration du flow
- `apps/flowc/agents/explore-agent.md` - Exploration codebase
- `apps/flowc/agents/architect-agent.md` - Options d'architecture
- `apps/flowc/agents/review-agent.md` - Review qualité
- `apps/flowc/hooks/guard-story-ready.sh` - Guard story ready
- `apps/flowc/.claude/settings.json` - Configuration hook

### Flow des agents

```
/work S-XXX
    │
    ├── Guard (story ready?)
    ├── Setup (session, branche)
    ├── explore-agent → fichiers, patterns, conventions
    ├── architect-agent → options, user choisit
    ├── Claude implémente (TDD)
    └── review-agent → qualité validée
```
