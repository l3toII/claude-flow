#!/bin/bash
# guard-secrets.sh - Warn about potential secrets before Write|Edit
# PreToolUse hook - WARNING mode (exit 0, but displays warning)
#
# This hook scans content being written for potential secrets.
# It warns but does NOT block the operation.

set -euo pipefail

# Read hook input from stdin
input=$(cat)

# Extract tool input (the content being written)
tool_input=$(echo "$input" | jq -r '.tool_input // empty')
content=$(echo "$tool_input" | jq -r '.content // empty')
file_path=$(echo "$tool_input" | jq -r '.file_path // empty')

# Skip if no content or empty
if [[ -z "$content" ]]; then
    exit 0
fi

# Skip certain file types that legitimately contain key-like strings
filename=$(basename "$file_path" 2>/dev/null || echo "")
case "$filename" in
    *.md|*.txt|*.json|*.lock|*.svg|*.png|*.jpg|*.gif)
        # Skip documentation, locks, and binary files
        exit 0
        ;;
    .env.example|.env.template|*.example)
        # Skip example/template files
        exit 0
        ;;
esac

# =============================================================================
# SECRET PATTERNS
# =============================================================================

declare -a PATTERNS=(
    # AWS
    'AKIA[0-9A-Z]{16}'
    'ASIA[0-9A-Z]{16}'

    # OpenAI
    'sk-[a-zA-Z0-9]{20,}'

    # Stripe
    'sk_live_[a-zA-Z0-9]{24,}'
    'sk_test_[a-zA-Z0-9]{24,}'
    'pk_live_[a-zA-Z0-9]{24,}'
    'pk_test_[a-zA-Z0-9]{24,}'

    # GitHub
    'ghp_[a-zA-Z0-9]{36}'
    'gho_[a-zA-Z0-9]{36}'
    'ghu_[a-zA-Z0-9]{36}'
    'ghs_[a-zA-Z0-9]{36}'
    'ghr_[a-zA-Z0-9]{36}'

    # GitLab
    'glpat-[a-zA-Z0-9\-_]{20,}'

    # Slack
    'xox[baprs]-[0-9]{10,}-[0-9]{10,}-[a-zA-Z0-9]{24}'

    # Private Keys
    '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'

    # Generic patterns (high confidence)
    'api[_-]?key["'\'']\s*[:=]\s*["'\''][a-zA-Z0-9]{32,}'
    'api[_-]?secret["'\'']\s*[:=]\s*["'\''][a-zA-Z0-9]{32,}'
    'secret[_-]?key["'\'']\s*[:=]\s*["'\''][a-zA-Z0-9]{32,}'
)

# =============================================================================
# SCAN CONTENT
# =============================================================================

warnings=()

for pattern in "${PATTERNS[@]}"; do
    if echo "$content" | grep -qE "$pattern" 2>/dev/null; then
        # Extract matching line for context
        match=$(echo "$content" | grep -oE ".{0,20}$pattern.{0,20}" 2>/dev/null | head -1)
        if [[ -n "$match" ]]; then
            # Mask the actual secret
            masked=$(echo "$match" | sed -E 's/([a-zA-Z0-9]{8})[a-zA-Z0-9]{10,}/\1***/g')
            warnings+=("$masked")
        fi
    fi
done

# =============================================================================
# OUTPUT WARNING (if any)
# =============================================================================

if [[ ${#warnings[@]} -gt 0 ]]; then
    echo "" >&2
    echo "╔══════════════════════════════════════════════════════════════════════╗" >&2
    echo "║  ⚠️  POTENTIAL SECRET DETECTED                                        ║" >&2
    echo "╚══════════════════════════════════════════════════════════════════════╝" >&2
    echo "" >&2
    echo "File: $file_path" >&2
    echo "" >&2
    echo "Detected patterns:" >&2
    for warning in "${warnings[@]}"; do
        echo "  • $warning" >&2
    done
    echo "" >&2
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
    echo "" >&2
    echo "💡 RECOMMENDATIONS:" >&2
    echo "   • Use environment variables instead of hardcoded secrets" >&2
    echo "   • Store secrets in apps/devops/env/.env (gitignored)" >&2
    echo "   • Use .env.example for templates (no real values)" >&2
    echo "" >&2
    echo "⚠️  This is a WARNING - the operation will proceed." >&2
    echo "   Please review if this is intentional." >&2
    echo "" >&2
fi

# Always exit 0 (warning mode, not blocking)
exit 0
