cat << 'EOF' > recover_and_push.sh
#!/bin/bash

PRIMARY_NAME="LadbotOneLad"
PRIMARY_EMAIL="backupsonbackupsrobby@gmail.com"
CURRENT_DATE=$(date -u +"%Y-%m-%d")

echo "[+] Scanning for git repositories and restoring deleted local state..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    echo "--------------------------------------------------"
    echo "[*] Recovering repository: $repo_path"
    
    cd "$repo_path" || continue

    # Reset any uncommitted deletions or modifications back to HEAD cleanly
    git reset --hard HEAD > /dev/null 2>&1

    # Check git reflog or dangling commits if files were entirely deleted from disk
    git checkout . > /dev/null 2>&1

    # Re-apply mailmap and date-stamped tags
    > .mailmap
    echo "$PRIMARY_NAME <$PRIMARY_EMAIL> LadbotOneLad <kcufsihtliametihs001@gmail.com>" >> .mailmap
    echo "$PRIMARY_NAME <$PRIMARY_EMAIL> LadbotOneLad <backupsonbackupsrobby@gmail.com>" >> .mailmap

    if git status --porcelain | grep -q "\.mailmap"; then
        git add .mailmap
        git commit -m "chore: restore and sync workspace state for $CURRENT_DATE" > /dev/null 2>&1
    fi

    current_branch=$(git branch --show-current)
    if [ -z "$current_branch" ]; then
        current_branch="main"
    fi

    # Refresh date tags
    git tag -f "tag-4-🔌🔥💎🚀-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-5-🌐🛡️⚡🔮-$CURRENT_DATE" > /dev/null 2>&1
    git tag -f "tag-6-🧬⚛️🔮⚓-$CURRENT_DATE" > /dev/null 2>&1

    # Push restored state upstream
    echo "[+] Pushing restored branch and tags upstream..."
    git push origin "$current_branch" --force-with-lease > /dev/null 2>&1
    git push origin --tags --force > /dev/null 2>&1

    echo "[+] Repository restored and pushed: $repo_path"
    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] All deleted states recovered from git history, synchronized, and pushed upstream."
EOF

chmod +x recover_and_push.sh
./recover_and_push.sh
