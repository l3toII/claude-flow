# flowc - Architecture & Conventions

## Type d'Application

**Type**: `claude-plugin`
**Langage**: Markdown + Bash
**Runtime**: Claude Code CLI

## Spécificités des Plugins Claude

Les plugins Claude Code sont des collections de fichiers markdown et scripts, pas du code compilé. Les règles classiques de développement ne s'appliquent pas directement.

### Ce qui n'existe PAS

| Concept classique | Raison |
|-------------------|--------|
| Tests unitaires | Pas de code exécutable à tester |
| Build | Pas de compilation |
| Coverage | Pas de code source mesurable |
| Staging | Repo public = prod directe |

### Ce qui les REMPLACE

| Alternative | Description |
|-------------|-------------|
| `test.md` | Scénarios de test manuels documentés |
| Validation syntaxique | `shellcheck` pour les scripts bash |
| Lint markdown | `markdownlint` (optionnel) |
| Tags git | Versioning via releases |

## Structure du Plugin

```
apps/flowc/
├── .claude-plugin/
│   └── plugin.json          # Manifest du plugin
├── commands/                 # Commandes /xxx
│   └── *.md
├── agents/                   # Agents autonomes
│   └── *-agent.md
├── skills/                   # Connaissances injectées
│   └── */SKILL.md
├── hooks/
│   └── hooks.json           # Hooks automatiques
├── scripts/                  # Scripts bash utilitaires
│   └── *.sh
├── test.md                   # Scénarios de test
└── README.md
```

## Environnements

| Env | Branch | Description |
|-----|--------|-------------|
| prod | `main` | Repo public, installable via `/plugin install` |

**Pas de staging** : Le repo est public et directement installable. `main` = prod.

## Workflow de Release

1. Développement sur feature branch
2. PR vers `main` avec review
3. Merge = déploiement prod immédiat
4. Tag pour versioning (`v0.1.0`, `v0.2.0`, etc.)

## Quality Gates Adaptés

### Avant PR (`/done`)

1. **test.md à jour** : Nouveaux scénarios pour nouvelles features
2. **Scripts valides** : `shellcheck scripts/*.sh` (si modifiés)
3. **Markdown valide** : Structure correcte des fichiers
4. **Documentation** : README et GUIDE.md à jour si besoin

### Review Checklist

- [ ] Commandes testées manuellement
- [ ] Scénarios test.md couvrent les cas d'usage
- [ ] Pas de secrets hardcodés dans les scripts
- [ ] Hooks fonctionnels
- [ ] Documentation cohérente

## Conventions de Code

### Scripts Bash

```bash
#!/bin/bash
set -euo pipefail  # Toujours en début de script

# Variables en UPPER_CASE pour les constantes
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Fonctions en snake_case
get_repo_name() {
  # ...
}

# Toujours quoter les variables
echo "$VARIABLE"  # Correct
echo $VARIABLE    # Incorrect
```

### Fichiers Markdown (Commands/Agents)

```markdown
---
name: command-name
description: One-line description
---

# Command Name

[Contenu structuré...]
```

### Skills

```markdown
---
name: skill-name
description: When to use this skill
---

# Skill Name

[Documentation de la compétence...]
```

## Test Manuel (test.md)

Le fichier `test.md` contient des scénarios de test à exécuter manuellement :

```markdown
## Scénario: /story création basique

**Setup**: Projet initialisé avec `/init`

**Steps**:
1. Exécuter `/story "Test feature"`
2. Vérifier création fichier `project/backlog/S-XXX.md`
3. Vérifier issue GitHub créée

**Expected**:
- Story ID incrémenté
- Fichier avec bon format YAML frontmatter
- Issue liée dans le fichier

**Teardown**: Supprimer la story créée
```

## Versioning

- **Format**: Semantic Versioning (`MAJOR.MINOR.PATCH`)
- **Source**: Tags git (`v0.1.0`)
- **Changelog**: `CHANGELOG.md` à la racine du plugin

### Quand incrémenter

| Type | Quand |
|------|-------|
| MAJOR | Breaking changes (renommage commandes, changement structure) |
| MINOR | Nouvelles features (nouvelles commandes, agents) |
| PATCH | Bug fixes, améliorations mineures |
