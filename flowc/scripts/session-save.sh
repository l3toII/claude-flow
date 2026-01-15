#!/bin/bash
# Save session state on stop

SESSION_FILE=".claude/session.json"

if [[ -f "$SESSION_FILE" ]]; then
    # Update last saved timestamp
    TEMP_FILE=$(mktemp)
    jq --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_saved = $now' "$SESSION_FILE" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$SESSION_FILE"
fi
