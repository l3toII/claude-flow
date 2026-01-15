---
id: S-003
title: Implémenter /work basique
type: feature
status: ready
sprint: sprint-00
created: 2025-01-15
---

# S-003: Implémenter /work basique

## Description

Créer la commande `/work` pour démarrer le travail sur une story.

## Critères d'Acceptation

- [ ] `/work S-XXX` démarre une session de travail
- [ ] Crée la branche feature depuis main
- [ ] Met à jour la story en status `active`
- [ ] Crée/met à jour `.claude/session.json`
- [ ] Option `--app` pour projets multi-app

## Notes Techniques

Fichier: `apps/flowc/commands/work.md`
