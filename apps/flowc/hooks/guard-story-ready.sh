#!/bin/bash
# Guard: Vérifie que la story est en status "ready" avant /work
#
# Exit codes:
#   0 - Story ready, continue
#   2 - Story not ready, block with message

# Lire l'input JSON depuis stdin
INPUT=$(cat)

# Extraire l'argument S-XXX de la commande
STORY_ID=$(echo "$INPUT" | grep -oE 'S-[0-9]+' | head -1)

if [ -z "$STORY_ID" ]; then
    echo "Erreur: Aucun ID de story fourni. Usage: /work S-XXX" >&2
    exit 2
fi

# Chercher le fichier story
STORY_FILE=$(find project/backlog -name "${STORY_ID}-*.md" 2>/dev/null | head -1)

if [ -z "$STORY_FILE" ]; then
    echo "Erreur: Story $STORY_ID non trouvée dans project/backlog/" >&2
    exit 2
fi

# Extraire le status du frontmatter
STATUS=$(grep -E '^status:' "$STORY_FILE" | head -1 | sed 's/status: *//')

if [ "$STATUS" != "ready" ]; then
    echo "Story $STORY_ID n'est pas ready (status: $STATUS)." >&2
    echo "Utilise '/story $STORY_ID' pour la passer en ready d'abord." >&2
    exit 2
fi

# Story is ready, allow /work to proceed
exit 0
