#!/bin/bash

PRIMARY_NAME="backupsonbackups-cyber"
PRIMARY_EMAIL="backupsonbackupsrobby@gmail.com"

echo "[+] Starting mass repository sync with primary email: $PRIMARY_EMAIL..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    echo "--------------------------------------------------"
    echo "[*] Processing repository: $repo_path"
    
    cd "$repo_path" || continue

    # 1. Mailmap Unification using the correct backups email
    > .mailmap
    git log --format='%aN <%aE>' | sort -u | while read -r author; do
        echo "$PRIMARY_NAME <$PRIMARY_EMAIL> $author" >> .mailmap
    done

    # Explicit mapping for alternate handles
    echo "$PRIMARY_NAME <$PRIMARY_EMAIL> backupsonbackups-cyber <backupsonbackupsrobby@gmail.com>" >> .mailmap

    if git status --porcelain | grep -q "\.mailmap"; then
        git add .mailmap
        git commit -m "chore: unify contributor identity mapping to backupsonbackupsrobby@gmail.com"
        echo "[+] Committed .mailmap updates."
    fi

    # 2. Create Emoji Branches (Branch 2 & Branch 3)
    for branch in "branch-2" "branch-3"; do
        if git show-ref --verify --quiet "refs/heads/$branch"; then
            git checkout "$branch" > /dev/null 2>&1
        else
            git checkout -b "$branch" > /dev/null 2>&1
            echo "[+] Created branch: $branch"
        fi

        # 3. Apply Emoji Tags (Tags 4, 5, 6)
        if [ "$branch" = "branch-2" ]; then
            git tag -f "tag-4-🔌🔥💎🚀" > /dev/null 2>&1
            git tag -f "tag-5-🌐🛡️⚡🔮" > /dev/null 2>&1
        elif [ "$branch" = "branch-3" ]; then
            git tag -f "tag-4-💻🤖🛰️🌌" > /dev/null 2>&1
            git tag -f "tag-5-🔋⚙️📡🧭" > /dev/null 2>&1
            git tag -f "tag-6-🧬⚛️🔮⚓" > /dev/null 2>&1
        fi

        # Push branch and tags upstream
        current_branch=$(git branch --show-current)
        echo "[+] Pushing branch $current_branch and tags upstream..."
        git push origin "$current_branch" --force-with-lease > /dev/null 2>&1
        git push origin --tags --force > /dev/null 2>&1
    done

    # Return to main/default branch or root workspace
    git checkout main > /dev/null 2>&1 || git checkout master > /dev/null 2>&1
    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] All repositories updated with correct email, branched, tagged, and pushed upstream."
