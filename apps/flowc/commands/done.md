---
description: Finalize work on a story. Runs review-agent, creates PR, updates session.
argument-hint: '[--force]'
skills: done
---

# /done - Finaliser le Travail sur une Story

Lance review-agent, crée la PR, met à jour la session.

## Usage

```bash
/done                        # Finalise le travail en cours
/done --force                # Skip review-agent (non recommandé)
```

## Prérequis

- Session active (`status: working` dans `.claude/session.json`)
- Tests manuels effectués par l'utilisateur

## Flow

```
/done
    │
    ├── 1. Analyse dirty files
    │   ├── Si fichiers non commités → analyse
    │   └── Demande user (commit/ignore/abort)
    │
    ├── 2. En parallèle
    │   ├── review-agent (code quality)
    │   └── quality gates (si app, pas plugin)
    │
    ├── 3. Résultats
    │   ├── Si issues critiques → bloquer, afficher fixes
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

## Agents

| Agent | Phase | Rôle |
|-------|-------|------|
| `review-agent` | 2 | Review qualité du code |

## Dirty Files Analysis

Si des fichiers non commités sont détectés :

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

Claude analyse chaque fichier et suggère une action appropriée.

## Quality Gates

| Contexte | Comportement |
|----------|--------------|
| App code | Tests + lint + coverage en parallèle de review-agent |
| Plugin | Pas de quality gates, juste review-agent |

## Review Agent

Lance `review-agent` sur les fichiers modifiés (git diff depuis main).

Si issues critiques :
- Affiche les problèmes avec suggestions de fix
- Bloque la création de PR
- User doit corriger et relancer `/done`

## PR Creation

Utilise le template `templates/pr.md` :

| Section | Source |
|---------|--------|
| Summary | Story description |
| Related | Story ID + Ticket app |
| Changes | Commits summary |
| Test Plan | Critères d'acceptation |
| Review | Verdict review-agent |

### Exemple PR générée

```markdown
## Summary

**Story**: [S-004](https://github.com/org/orchestrator/blob/main/project/backlog/S-004-done-command.md) - Implémenter /done basique
**Ticket**: Closes #15

Après `/work`, Claude a implémenté la feature...

## Related

| Type | Reference |
|------|-----------|
| Story (orchestrator) | S-004 |
| Ticket (api) | Closes #15 |

## Changes

- feat(done): add done command and skill
- feat(done): add PR template

...
```

## Session après /done

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

La session est conservée avec `status: review` pour :
- Permettre de reprendre si PR refusée
- Tracer quelle story est en review
- Permettre à `/sync` de détecter le merge

## Exemple complet

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

## Options

| Option | Description |
|--------|-------------|
| `--force` | Skip review-agent (non recommandé, pour urgences) |

## Erreurs

| Erreur | Cause | Solution |
|--------|-------|----------|
| Pas de session | Pas de `/work` en cours | Lancer `/work S-XXX` d'abord |
| Issues critiques | Review-agent a trouvé des problèmes | Corriger et relancer `/done` |
| Push failed | Conflit ou permissions | Résoudre manuellement |

## Règles

1. **Review obligatoire** : Sauf avec `--force`
2. **Issues critiques bloquent** : Pas de PR tant que non corrigées
3. **Session conservée** : Permet reprise si PR refusée
4. **Template PR** : Toujours utiliser le template

## Fichiers

| Fichier | Rôle |
|---------|------|
| `commands/done.md` | Cette définition de commande |
| `skills/done.md` | Orchestration du flow |
| `templates/pr.md` | Template PR |
| `agents/review-agent.md` | Review qualité |
