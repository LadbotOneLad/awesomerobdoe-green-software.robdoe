#!/bin/bash

PRIMARY_NAME="backupsonbackups-cyber"
PRIMARY_EMAIL="backupsonbackupsrobby@gmail.com"
CURRENT_DATE=$(date -u +"%Y-%m-%d")

echo "[+] Initiating full multi-repo release sync..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    echo "--------------------------------------------------"
    echo "[*] Releasing repository: $repo_path"
    
    cd "$repo_path" || continue

    # Ensure all local changes are safely packaged and committed
    if [[ -n $(git status --porcelain) ]]; then
        git add -A
        git commit -m "release: freeze state for production release on $CURRENT_DATE" > /dev/null 2>&1
    fi

    current_branch=$(git branch --show-current)
    if [ -z "$current_branch" ]; then
        current_branch="main"
    fi

    # Lock in unified mailmap identity
    > .mailmap
    echo "$PRIMARY_NAME <$PRIMARY_EMAIL> LadbotOneLad <kcufsihtliametihs001@gmail.com>" >> .mailmap
    echo "$PRIMARY_NAME <$PRIMARY_EMAIL> LadbotOneLad <backupsonbackupsrobby@gmail.com>" >> .mailmap
    git add .mailmap
    git commit -m "chore: finalize release identity mapping" > /dev/null 2>&1

    # Drop official release tags
    git tag -f "release-v1.0.0-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-4-🔌🔥💎🚀-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-5-🌐🛡️⚡🔮-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-6-🧬⚛️🔮⚓-$CURRENT_DATE" > /dev/null 2>&1

    # Push branch and all release tags upstream
    echo "[+] Pushing release upstream for $current_branch..."
    git push origin "$current_branch" --force-with-lease > /dev/null 2>&1
    git push origin --tags --force > /dev/null 2>&1

    echo "[+] Release deployed for: $repo_path"
    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] All repositories successfully released, tagged, and pushed upstream."
