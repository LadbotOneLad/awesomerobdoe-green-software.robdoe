#!/bin/bash

# Configuration
PRIMARY_NAME="LadbotOneLad"
EMAILS=("kcufsihtliametihs001@gmail.com" "backupsonbackupsrobby@gmail.com")
CURRENT_DATE=$(date -u +"%Y-%m-%d")

echo "[+] Starting synchronized Symphony tag push with date stamps across all emails..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    echo "--------------------------------------------------"
    echo "[*] Processing repository: $repo_path"
    
    cd "$repo_path" || continue

    # 1. Update .mailmap to cover both target emails
    > .mailmap
    for email in "${EMAILS[@]}"; do
        echo "$PRIMARY_NAME <$email> $PRIMARY_NAME <$email>" >> .mailmap
        git log --format='%aN <%aE>' | sort -u | while read -r author; do
            echo "$PRIMARY_NAME <$email> $author" >> .mailmap
        done
    done

    if git status --porcelain | grep -q "\.mailmap"; then
        git add .mailmap
        git commit -m "chore: unify contributor identities for $CURRENT_DATE"
        echo "[+] Committed .mailmap updates."
    fi

    # 2. Get active branch
    current_branch=$(git branch --show-current)
    if [ -z "$current_branch" ]; then
        current_branch="main"
    fi

    # 3. Apply Date-Stamped Symphony Tags
    git tag -f "tag-4-🔌🔥💎🚀-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-5-🌐🛡️⚡🔮-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-6-🧬⚛️🔮⚓-$CURRENT_DATE" > /dev/null 2>&1

    echo "[+] Applied date-stamped tags for $CURRENT_DATE on branch $current_branch"

    # 4. Push upstream
    git push origin "$current_branch" --force-with-lease > /dev/null 2>&1
    git push origin --tags --force > /dev/null 2>&1
    echo "[+] Pushed upstream successfully."

    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] Symphony date-stamped tag push complete across all repositories and identities."
