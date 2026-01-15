#!/bin/bash
# Guard: Warn about potential secrets in files

# Get the file being written/edited from tool input
FILE_PATH="$CLAUDE_TOOL_INPUT_FILE_PATH"

if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# Check file extension - skip binary and known safe files
case "$FILE_PATH" in
    *.png|*.jpg|*.gif|*.ico|*.woff|*.ttf|*.lock|*.sum)
        exit 0
        ;;
esac

# Get content to check
CONTENT="$CLAUDE_TOOL_INPUT_CONTENT"
if [[ -z "$CONTENT" ]]; then
    CONTENT="$CLAUDE_TOOL_INPUT_NEW_STRING"
fi

if [[ -z "$CONTENT" ]]; then
    exit 0
fi

# Patterns that might indicate secrets
PATTERNS=(
    "password\s*[:=]"
    "api[_-]?key\s*[:=]"
    "secret\s*[:=]"
    "token\s*[:=]"
    "private[_-]?key"
    "-----BEGIN.*PRIVATE KEY-----"
    "aws[_-]?access[_-]?key"
    "aws[_-]?secret"
)

WARNING=""
for pattern in "${PATTERNS[@]}"; do
    if echo "$CONTENT" | grep -qiE "$pattern"; then
        WARNING="[flowc] Warning: Potential secret detected in $FILE_PATH. Please ensure no credentials are being committed."
        break
    fi
done

if [[ -n "$WARNING" ]]; then
    echo "{\"systemMessage\": \"$WARNING\"}"
fi
