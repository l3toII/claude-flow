#!/bin/bash
# Session start hook

SESSION_FILE=".claude/session.json"
SESSION_DIR=".claude"

# Create session directory if needed
mkdir -p "$SESSION_DIR"

# Initialize or load session
if [[ -f "$SESSION_FILE" ]]; then
    # Resume existing session
    TICKET=$(jq -r '.active_ticket // ""' "$SESSION_FILE" 2>/dev/null)
    STATUS=$(jq -r '.status // "idle"' "$SESSION_FILE" 2>/dev/null)

    if [[ -n "$TICKET" && "$STATUS" == "working" ]]; then
        echo "{\"systemMessage\": \"[flowc] Resuming session. Active: $TICKET. Use /status for details.\"}"
    fi
else
    # New session
    cat > "$SESSION_FILE" << EOF
{
  "status": "idle",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
fi
