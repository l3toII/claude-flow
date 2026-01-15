#!/bin/bash
# Guard: Check if committing on a valid story branch

BRANCH=$(git branch --show-current 2>/dev/null)

# Skip check for main branches
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" || "$BRANCH" == "develop" ]]; then
    exit 0
fi

# Block poc/vibe branches from commits that might be merged
if [[ "$BRANCH" == poc/* || "$BRANCH" == vibe/* ]]; then
    cat << EOF
{
  "systemMessage": "[flowc] Warning: You're on a $BRANCH branch. These are for exploration only and should not be merged. Consider creating a proper feature branch with /work."
}
EOF
fi

# Check for story reference in branch name
if ! echo "$BRANCH" | grep -qE "(S-[0-9]+|#[0-9]+|feature/|fix/|feat/)"; then
    cat << EOF
{
  "systemMessage": "[flowc] Note: Branch '$BRANCH' doesn't follow naming conventions. Use /work S-XXX to create properly named branches."
}
EOF
fi
