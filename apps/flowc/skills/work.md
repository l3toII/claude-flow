---
name: work
description: Orchestrates /work command. Runs explore-agent, architect-agent, then Claude implements with TDD.
---

# Work Skill

Orchestre la commande `/work`. Lance explore-agent, architect-agent, puis Claude implémente en TDD.

## Déclenchement

Invoqué par `/work S-XXX` après validation du guard (story must be ready).

## Flow obligatoire

```
/work S-XXX
    │
    ├── 1. [Guard] Story ready ?
    │
    ├── 2. Setup technique
    │   ├── Lire la story
    │   ├── Créer session.json
    │   ├── Story status → active
    │   └── Créer branche
    │
    ├── 3. explore-agent (OBLIGATOIRE)
    │   └── Comprendre le codebase
    │
    ├── 4. architect-agent (OBLIGATOIRE)
    │   └── Choisir l'approche
    │
    └── 5. Claude implémente (TDD)
        └── User teste manuellement, puis /done
```

## Phase 1-2 : Setup

### Lire la story

```bash
project/backlog/S-XXX-*.md
```

Extraire :
- `status` (doit être `ready`)
- `sprint` pour session.json
- `title` pour le slug de branche
- `acceptance criteria` pour l'implémentation

### Créer session.json

```json
{
  "active_story": "S-XXX",
  "active_app": "<app-name>",
  "branch": "feature/#XXX-slug",
  "started_at": "<ISO-timestamp>",
  "status": "working",
  "current_sprint": "<sprint-id>"
}
```

### Mettre à jour le status

```yaml
status: active  # était: ready
```

### Créer la branche

```bash
git checkout main && git pull
git checkout -b feature/#XXX-slug
```

## Phase 3 : explore-agent

**OBLIGATOIRE** - Toujours lancer avant de coder.

```
Lance explore-agent avec:
  Explore: [ce que la story demande]
  Contexte: [résumé de la story]
```

Attendre le retour :
- Fichiers clés à lire
- Patterns identifiés
- Conventions du projet

## Phase 4 : architect-agent

**OBLIGATOIRE** - Toujours proposer des options.

```
Lance architect-agent avec:
  Architecture: [ce qu'il faut concevoir]
  Contexte: [output de explore-agent]
```

Attendre le retour :
- 2-3 options avec trade-offs
- Recommandation

**ATTENDRE que l'utilisateur choisisse** avant d'implémenter.

## Phase 5 : Implémentation TDD

**Claude implémente** en suivant :
- L'architecture choisie par l'utilisateur
- Les patterns identifiés par explore-agent
- Le cycle TDD

### TDD obligatoire

```
1. RED    : Écrire un test qui échoue
2. GREEN  : Code MINIMAL pour passer
3. REFACTOR : Améliorer sans casser
4. REPEAT
```

### Règles TDD

- **JAMAIS** de code sans test d'abord
- **TOUJOURS** voir le test échouer
- **TOUJOURS** un seul test à la fois
- **JAMAIS** plus de code que nécessaire

### Exception plugins

Pour les plugins Claude (markdown) :
- Pas de tests unitaires
- Documenter tests manuels dans `test.md`

## Détection du contexte

### Plugin Claude

```
Pas de apps/ avec sous-repos
OU apps/flowc sans .git propre
```
→ Pas de ticket GitHub, branche depuis ID story

### Mono-app

```
apps/
└── api/
    └── .git/
```
→ Pas besoin de `--app`, auto-détecté

### Multi-app

```
apps/
├── api/
│   └── .git/
└── web/
    └── .git/
```
→ `--app` requis, ticket créé dans repo app

## Output attendu

```
✓ Story S-042 chargée (ready → active)
✓ Session configurée (.claude/session.json)
✓ Branche feature/#042-slug créée

## Phase 3: Exploration
→ Lance explore-agent...

[Résultat explore-agent]

## Phase 4: Architecture
→ Lance architect-agent...

[Options présentées]
Quelle approche choisissez-vous ?

[User choisit]

## Phase 5: Implémentation TDD

RED: test X
GREEN: impl X
REFACTOR: ...

[Continue...]

✓ Implémentation terminée
→ Testez manuellement, puis /done pour créer la PR
```
