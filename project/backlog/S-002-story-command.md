---
id: S-002
title: Implémenter /story basique
type: feature
status: ready
sprint: sprint-00
created: 2025-01-15
---

# S-002: Implémenter /story basique

## Description

Créer la commande `/story` pour créer des stories dans le backlog.

## Critères d'Acceptation

- [ ] `/story "titre"` crée un fichier dans `project/backlog/`
- [ ] ID auto-incrémenté (S-XXX)
- [ ] Frontmatter YAML valide
- [ ] Option `--type` (feature, tech, bug)
- [ ] Option `--sprint` pour assigner directement

## Notes Techniques

Fichier: `apps/flowc/commands/story.md`
