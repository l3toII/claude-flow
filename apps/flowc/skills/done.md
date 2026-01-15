---
name: done
description: Orchestrates /done command. Analyzes dirty files, runs review-agent, creates PR, updates session.
---

# Done Skill

Orchestre la commande `/done`. Analyse les fichiers non commités, lance review-agent, crée la PR, met à jour la session.

## Déclenchement

Invoqué par `/done` après que l'utilisateur a testé manuellement.

## Flow obligatoire

```
/done
    │
    ├── 1. Vérifier session active
    │   └── Guard si pas de session working
    │
    ├── 2. Analyse dirty files
    │   ├── Détecter fichiers non commités
    │   ├── Analyser chaque fichier
    │   └── Demander action à l'utilisateur
    │
    ├── 3. En parallèle
    │   ├── review-agent (OBLIGATOIRE)
    │   └── quality gates (si app code)
    │
    ├── 4. Évaluer résultats
    │   ├── Si issues critiques → bloquer
    │   └── Si OK → continuer
    │
    ├── 5. Créer PR
    │   ├── Commit + push
    │   ├── gh pr create
    │   └── Afficher lien
    │
    └── 6. Mise à jour session
        └── status: review + pr_url
```

## Phase 1 : Vérifier session

Lire `.claude/session.json` :

```json
{
  "active_story": "S-004",
  "status": "working"
}
```

**Guard** : Si pas de session ou `status != working` → bloquer avec message "Lance /work d'abord".

## Phase 2 : Analyse dirty files

### Détecter

```bash
git status --porcelain
```

### Analyser

Pour chaque fichier non commité, déterminer :
- Type de changement (modifié, nouveau, supprimé)
- Raison probable (debug, config, oubli, intentionnel)
- Action suggérée (commit, ignore, review)

### Demander

```
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

**ATTENDRE** la réponse de l'utilisateur avant de continuer.

## Phase 3 : Review & Quality Gates

### En parallèle

Lancer simultanément :

1. **review-agent** (OBLIGATOIRE)
   ```
   Lance review-agent avec:
     Review: [fichiers modifiés depuis main]
     Contexte: [story S-XXX, implémentation de...]
   ```

2. **quality gates** (si app code, pas plugin)
   ```bash
   npm test
   npm run lint
   npm run build
   ```

### Pour plugins

Pas de quality gates automatiques :
- Pas de tests unitaires (markdown)
- Pas de lint (sauf shellcheck sur .sh)
- Juste review-agent

## Phase 4 : Évaluer résultats

### Si issues critiques

```
## Review Results
- Issues critiques: 2
- Issues importantes: 1
- Issues mineures: 3

### Issues critiques (à corriger)

1. **Erreur silencieuse** - `commands/done.md:L42`
   → Le catch ne log pas l'erreur

2. **Injection possible** - `skills/done.md:L89`
   → Input non sanitizé

✗ Création PR bloquée
→ Corriger les issues critiques et relancer /done
```

**BLOQUER** : Ne pas créer la PR.

### Si OK

```
## Review Results
- Issues critiques: 0
- Issues importantes: 1 (naming convention)
- Issues mineures: 2

✓ Aucune issue bloquante
→ Création PR...
```

**CONTINUER** vers la création de PR.

## Phase 5 : Créer PR

### Commit + Push

```bash
git add .
git commit -m "feat(S-XXX): [description]"
git push -u origin [branch]
```

### Créer PR

Utiliser le template `templates/pr.md` :

```bash
gh pr create \
  --title "feat(S-XXX): [story title]" \
  --body "[template rempli]"
```

### Remplir le template

| Variable | Source |
|----------|--------|
| `{{story_id}}` | session.json → active_story |
| `{{story_title}}` | Story file → title |
| `{{story_context}}` | Story file → Contexte section |
| `{{app_ticket_number}}` | session.json → active_ticket |
| `{{app_name}}` | session.json → active_app |
| `{{commits_summary}}` | `git log --oneline main..HEAD` |
| `{{files_changed_list}}` | `git diff --name-only main` |
| `{{files_count}}` | Nombre de fichiers |
| `{{acceptance_criteria_as_checklist}}` | Story file → Critères |
| `{{review_agent_verdict}}` | Output review-agent |

### Afficher

```
✓ PR créée: https://github.com/org/api/pull/16
```

## Phase 6 : Mise à jour session

### Mettre à jour session.json

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

### Ne PAS mettre à jour la story

La story reste `active` jusqu'au `/sync` qui détectera le merge.

## Output attendu

```
User: /done

Claude:
  ## Analyse
  ✓ Session active (S-004)
  ✓ Working tree propre

  ## Review & Quality (en parallèle)
  → review-agent...
  → quality gates... (skipped - plugin)

  ## Review Results
  - Issues critiques: 0
  - Issues importantes: 1
  - Issues mineures: 2

  ✓ Aucune issue bloquante

  ## Création PR
  → Committing changes...
  → Pushing to origin/feature/#004-done-command
  → Creating PR...

  ✓ PR créée: https://github.com/org/api/pull/16

  ## Session
  ✓ Status: working → review
  ✓ PR tracked in session.json

  Prochaine étape: review par l'équipe, puis /sync après merge
```

## Option --force

Si `--force` est passé :
- Skip review-agent
- Crée la PR directement
- **Non recommandé** sauf urgence

```
User: /done --force

Claude:
  ⚠️ Mode force activé - review-agent skippé

  ## Création PR
  → Pushing...
  → Creating PR...

  ✓ PR créée: https://github.com/org/api/pull/16

  ⚠️ Attention: PR créée sans review automatique
```

## Gestion des erreurs

| Erreur | Action |
|--------|--------|
| Pas de session | "Lance /work d'abord" |
| Session pas working | "Session en status [X], attendu: working" |
| Issues critiques | Afficher, bloquer, suggérer fixes |
| Push failed | Afficher erreur git, suggérer résolution |
| PR creation failed | Afficher erreur gh, vérifier permissions |
