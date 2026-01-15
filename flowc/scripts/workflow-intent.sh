#!/bin/bash
# Intent detection for natural language workflow

USER_PROMPT="$CLAUDE_USER_PROMPT"

# Skip if empty or a command
[[ -z "$USER_PROMPT" ]] && exit 0
[[ "$USER_PROMPT" == /* ]] && exit 0

# Session state
SESSION_FILE=".claude/session.json"
if [[ -f "$SESSION_FILE" ]]; then
    STATUS=$(jq -r '.status // "idle"' "$SESSION_FILE" 2>/dev/null)
    TICKET=$(jq -r '.active_ticket // ""' "$SESSION_FILE" 2>/dev/null)
else
    STATUS="no_session"
    TICKET=""
fi

# Detect intent
detect_intent() {
    local prompt="$1"
    prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

    # Code requests
    if echo "$prompt_lower" | grep -qE "(implement|create|add|build|write|develop|code|feature|function)"; then
        echo "CODE_REQUEST"
        return
    fi

    # Bug fixes
    if echo "$prompt_lower" | grep -qE "(fix|bug|error|issue|problem|broken|doesnt work|not working)"; then
        echo "BUG_FIX"
        return
    fi

    # Story related
    if echo "$prompt_lower" | grep -qE "(story|user story|feature request|backlog|requirement)"; then
        echo "STORY_RELATED"
        return
    fi

    # Status queries
    if echo "$prompt_lower" | grep -qE "(status|progress|whats next|where are we|current)"; then
        echo "STATUS_REQUEST"
        return
    fi

    echo "GENERAL"
}

INTENT=$(detect_intent "$USER_PROMPT")

# Generate context based on state and intent
generate_context() {
    case "$STATUS:$INTENT" in
        "no_session:CODE_REQUEST"|"idle:CODE_REQUEST")
            cat << 'EOF'
{
  "systemMessage": "[flowc] No active work session. To write code:\n1. /story \"Feature title\" - Create a story\n2. /work S-XXX - Start working\n3. Implement...\n4. /done - Complete with PR"
}
EOF
            ;;
        "working:CODE_REQUEST")
            cat << EOF
{
  "systemMessage": "[flowc] Active: $TICKET. Implement the requested changes, then use /done when complete."
}
EOF
            ;;
        *":STATUS_REQUEST")
            cat << 'EOF'
{
  "systemMessage": "[flowc] Use /status to see project status, or /sprint for sprint details."
}
EOF
            ;;
        *)
            echo '{}'
            ;;
    esac
}

generate_context
