---
id: S-004
title: Implémenter /done basique
type: feature
status: ready
sprint: sprint-00
created: 2025-01-15
---

# S-004: Implémenter /done basique

## Description

Créer la commande `/done` pour terminer le travail et créer une PR.

## Critères d'Acceptation

- [ ] `/done` vérifie les quality gates (test.md pour plugins)
- [ ] Crée la PR vers main
- [ ] Met à jour la story en status `review`
- [ ] Clear la session
- [ ] Affiche le lien de la PR

## Notes Techniques

Fichier: `apps/flowc/commands/done.md`

Pour apps type plugin:
- Vérifier que test.md est à jour
- Pas de tests unitaires à runner
