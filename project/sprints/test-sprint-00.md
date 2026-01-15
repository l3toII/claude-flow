---
sprint: sprint-00
type: test
status: pending
---

# Tests Sprint 00

Tests d'acceptation pour valider les stories du sprint 00.

## S-002: /story avec clarification interactive

| # | Test | Commande | Résultat attendu | Status |
|---|------|----------|------------------|--------|
| 1 | Création simple | `/story "Ajouter bouton logout"` | Flow interactif, confirmation, fichier créé | [ ] |
| 2 | Détection multi-stories | `/story "Login Google et reset password"` | Claude identifie 2 stories distinctes | [ ] |
| 3 | Clarification | `/story "Améliorer l'onboarding"` | Claude pose des questions | [ ] |
| 4 | Confirmation avant création | (suite de 1) | Claude demande confirmation | [ ] |
| 5 | Fichier créé | (suite de 1) | `project/backlog/S-XXX-slug.md` existe | [ ] |
| 6 | Template narratif | (suite de 5) | Sections: Contexte, Objectif, Description, Critères, Hors scope | [ ] |
| 7 | ID auto-incrémenté | Créer 2 stories | IDs séquentiels (S-005, S-006...) | [ ] |
| 8 | Force type | `/story tech "Refactorer auth"` | Type = tech dans le fichier | [ ] |
| 9 | Question GitHub | (après confirmation) | "Créer l'issue GitHub ?" | [ ] |
| 10 | Création issue | Répondre "oui" | Issue créée, lien dans frontmatter | [ ] |
| 11 | Option --draft | `/story --draft "Feature X"` | Pas de question GitHub, status = draft | [ ] |
| 12 | Option --ready | `/story --ready "Feature Y"` | Issue créée sans question, status = ready | [ ] |

## S-003: /work basique

| # | Test | Commande | Résultat attendu | Status |
|---|------|----------|------------------|--------|
| 1 | Story not ready bloquée | `/work S-XXX` (draft) | Guard bloque avec message "utilise /story d'abord" | [ ] |
| 2 | Story ready acceptée | `/work S-XXX` (ready) | Setup démarre | [ ] |
| 3 | Session créée | (suite de 2) | `.claude/session.json` créé avec active_story, branch, etc. | [ ] |
| 4 | Status updated | (suite de 2) | Story passe de `ready` à `active` | [ ] |
| 5 | Branche créée | (suite de 2) | `git branch` montre `feature/#XXX-slug` | [ ] |
| 6 | explore-agent lancé | (suite de 2) | Agent explore le codebase, retourne fichiers/patterns | [ ] |
| 7 | architect-agent lancé | (suite de 6) | Agent propose 2-3 options d'architecture | [ ] |
| 8 | User choisit architecture | (suite de 7) | Claude attend le choix avant d'implémenter | [ ] |
| 9 | TDD respecté | (après choix) | Claude écrit test d'abord (RED), puis code (GREEN) | [ ] |
| 10 | Fin implémentation | (après TDD) | Message "Testez manuellement, puis /done" | [ ] |
| 11 | Option --app | `/work S-XXX --app api` | Ticket créé dans repo api (multi-app) | [ ] |
| 12 | Plugin mode | `/work S-XXX` (ce repo) | Pas de ticket GitHub, branche depuis ID story | [ ] |

## S-004: /done basique

| # | Test | Commande | Résultat attendu | Status |
|---|------|----------|------------------|--------|
| 1 | Dirty files détectés | `/done` (avec fichiers non commités) | Analyse + demande user (commit/ignore/abort) | [ ] |
| 2 | Working tree propre | `/done` (tout commité) | Passe directement à review | [ ] |
| 3 | review-agent lancé | (suite de 2) | Agent review les fichiers modifiés | [ ] |
| 4 | Quality gates (app) | `/done` (dans app code) | Tests + lint + coverage en parallèle | [ ] |
| 5 | Quality gates skip (plugin) | `/done` (dans plugin) | Pas de quality gates, juste review-agent | [ ] |
| 6 | Issues critiques bloquent | (review avec issues critiques) | PR non créée, suggestions de fix affichées | [ ] |
| 7 | PR créée | (review OK) | `gh pr create` avec template rempli | [ ] |
| 8 | Template PR | (suite de 7) | Summary (story) + Changes (commits) + Test Plan (critères) | [ ] |
| 9 | Closes ticket | (suite de 7) | `Closes #XX` dans le body | [ ] |
| 10 | Session updated | (suite de 7) | `status: review`, `pr_url`, `pr_created_at` | [ ] |
| 11 | Lien PR affiché | (suite de 7) | URL de la PR affichée à la fin | [ ] |
| 12 | Message next step | (suite de 11) | "review par l'équipe, puis /sync après merge" | [ ] |

## Résumé

| Story | Tests | Passés | Échoués |
|-------|-------|--------|---------|
| S-002 | 12 | 0 | 0 |
| S-003 | 12 | 0 | 0 |
| S-004 | 12 | 0 | 0 |

## Notes

- Exécuter les tests après merge de chaque feature
- Cocher [x] quand le test passe
- Documenter les bugs trouvés dans la section Notes
