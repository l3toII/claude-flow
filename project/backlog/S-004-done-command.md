---
id: S-004
title: Implémenter /done basique
type: feature
status: done
sprint: sprint-00
created: 2025-01-15
---

# S-004: Implémenter /done basique

## Contexte

Après `/work`, Claude a implémenté la feature et l'utilisateur a testé manuellement. La commande `/done` finalise le travail : lance review-agent, vérifie la qualité, crée la PR, et met à jour la session.

Dans un contexte multi-app (orchestrator + apps séparées), la story reste dans l'orchestrator tandis que la PR est créée dans le repo de l'app.

## Objectif

En tant que développeur,
je veux lancer `/done` pour finaliser mon travail
afin d'avoir une PR créée, le code reviewé, et la session mise à jour.

## Description

La commande `/done` doit :

1. **Analyser les fichiers non commités** :
   - Si dirty working tree → analyser pourquoi ces fichiers existent
   - Demander à l'utilisateur quoi faire (commit, ignore, abort)

2. **En parallèle** :
   - Lancer `review-agent` sur les fichiers modifiés
   - Pour apps code : lancer quality gates (tests, lint, coverage)
   - Pour plugins : pas de quality gates, juste review-agent

3. **Si review OK** :
   - Commit + push dans l'app
   - Créer la PR (template + story + commits)
   - Mettre à jour session.json (`status: review`, `pr_url`)

4. **Story status** :
   - Reste `active` jusqu'au `/sync`
   - `/sync` détecte PR mergée → story `done`

### Flow

```
/done
    │
    ├── 1. Analyse dirty files
    │   └── Si non commités → analyse + demande user
    │
    ├── 2. En parallèle
    │   ├── review-agent (code quality)
    │   └── quality gates (si app, pas plugin)
    │
    ├── 3. Résultats
    │   ├── Si issues critiques → afficher, bloquer
    │   └── Si OK → continuer
    │
    ├── 4. Créer PR
    │   ├── Commit + push (si nécessaire)
    │   ├── gh pr create (template rempli)
    │   └── Afficher lien PR
    │
    └── 5. Mise à jour session
        ├── status: review
        ├── pr_url: https://...
        └── pr_created_at: timestamp
```

### Template PR

Utilise le template `apps/flowc/templates/pr.md` :

- **Summary** : depuis la story (description)
- **Related Issue** : `Closes #XX` (ticket app)
- **Changes** : depuis les commits
- **Test Plan** : depuis les critères d'acceptation
- **Screenshots** : si changements UI
- **Breaking Changes** : si applicable
- **Checklist** : review manuelle

### Session après /done

```json
{
  "active_story": "S-004",
  "active_app": "api",
  "branch": "feature/#15-done-command",
  "started_at": "2025-01-15T10:00:00Z",
  "status": "review",
  "pr_url": "https://github.com/org/api/pull/16",
  "pr_created_at": "2025-01-15T14:30:00Z"
}
```

## Critères d'acceptation

- [x] `/done` détecte les fichiers non commités et demande quoi faire
- [x] `review-agent` est lancé sur les fichiers modifiés
- [x] Quality gates lancés en parallèle (pour apps code)
- [x] Pour plugins : pas de quality gates, juste review-agent
- [x] Issues critiques bloquent la création de PR
- [x] PR créée avec template rempli (story + commits)
- [x] `Closes #XX` inclus pour fermeture auto du ticket
- [x] Session mise à jour avec `status: review` et `pr_url`
- [x] Lien PR affiché à la fin
- [x] Template PR créé dans `apps/flowc/templates/pr.md`

## Hors scope

- Passage automatique story `review` → `done` (voir `/sync`)
- Gestion des PR refusées (future story)
- Squash commits avant PR (future story)

## Notes techniques

Fichiers à créer :
- `apps/flowc/commands/done.md` - Définition de la commande
- `apps/flowc/skills/done.md` - Orchestration du flow
- `apps/flowc/templates/pr.md` - Template PR

Flow review-agent dans /done :
- Reçoit la liste des fichiers modifiés (git diff)
- Retourne issues critiques/importantes/mineures
- Si critiques → bloque avec suggestions de fix

### Dirty files analysis

```
/done

Claude:
  ⚠️ Fichiers non commités détectés :

  - src/utils/helper.ts (modifié)
    → Semble être du debug oublié (console.log ajoutés)

  - .env.local (nouveau)
    → Fichier d'environnement, ne devrait pas être commité

  Que faire ?
  1. Commit helper.ts, ignore .env.local
  2. Ignorer tout
  3. Annuler /done
```

### Exemple output

```
User: /done

Claude:
  ## Analyse
  ✓ Working tree propre

  ## Review & Quality (en parallèle)
  → review-agent...
  → quality gates... (skipped - plugin)

  ## Review Results
  - Issues critiques: 0
  - Issues importantes: 1 (naming convention L42)
  - Issues mineures: 2

  ✓ Aucune issue bloquante

  ## Création PR
  → Pushing to origin/feature/#004-done-command
  → Creating PR...

  ✓ PR créée: https://github.com/org/api/pull/16

  ## Session
  ✓ Status: working → review
  ✓ PR tracked in session.json

  Prochaine étape: review par l'équipe, puis /sync après merge
```
